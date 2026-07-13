#include "history.h"
#include "config.h"
#include <nlohmann/json.hpp>
#include <fstream>
#include <algorithm>
#include <ctime>
#include <iomanip>
#include <sstream>

using json = nlohmann::json;

// ──────────────────────────────────────────────
// 获取当前时间的 ISO 8601 字符串
// ──────────────────────────────────────────────
static std::string current_timestamp()
{
    auto now = std::chrono::system_clock::now();
    auto t = std::chrono::system_clock::to_time_t(now);
    std::stringstream ss;
    ss << std::put_time(std::gmtime(&t), "%Y-%m-%dT%H:%M:%SZ");
    return ss.str();
}

// ──────────────────────────────────────────────
// 追加历史记录
// ──────────────────────────────────────────────
void HistoryManager::append(const HistoryEntry& entry)
{
    std::string path = ConfigManager::get_history_path();

    // 读取现有历史
    json j = json::array();
    std::ifstream fin(path);
    if (fin.good()) {
        try {
            fin >> j;
        } catch (...) {
            j = json::array();
        }
    }

    if (!j.is_array()) j = json::array();

    // 构造新条目
    json entry_j;
    entry_j["timestamp"]       = entry.timestamp;
    entry_j["mode"]            = entry.mode;
    entry_j["total_chars"]     = entry.total_chars;
    entry_j["accuracy"]        = entry.accuracy;
    entry_j["cpm"]             = entry.cpm;
    entry_j["duration_secs"]   = entry.duration_secs;
    entry_j["dropped_samples"] = entry.dropped_samples;
    entry_j["group_size"]      = entry.group_size;
    entry_j["allow_backspace"] = entry.allow_backspace;

    // top 5 错误
    json top_j = json::array();
    int count = 0;
    for (const auto& [ch, errs] : entry.top_errors) {
        if (count >= 5) break;
        json item;
        item["key"] = std::string(1, ch);
        item["errors"] = errs;
        top_j.push_back(item);
        count++;
    }
    entry_j["top_errors"] = top_j;

    j.push_back(entry_j);
    // 只保留最近 100 条
    while (static_cast<int>(j.size()) > 100) {
        j.erase(j.begin());
    }

    std::ofstream fout(path);
    fout << j.dump(2) << std::endl;
}

// ──────────────────────────────────────────────
// 读取所有历史记录
// ──────────────────────────────────────────────
std::vector<HistoryEntry> HistoryManager::load()
{
    std::string path = ConfigManager::get_history_path();
    std::vector<HistoryEntry> result;

    std::ifstream fin(path);
    if (!fin.good()) return result;

    try {
        json j;
        fin >> j;
        if (!j.is_array()) return result;

        for (const auto& item : j) {
            HistoryEntry entry;
            entry.timestamp       = item.value("timestamp", "");
            entry.mode            = item.value("mode", "");
            entry.total_chars     = item.value("total_chars", 0);
            entry.accuracy        = item.value("accuracy", 0.0);
            entry.cpm             = item.value("cpm", 0.0);
            entry.duration_secs   = item.value("duration_secs", 0.0);
            entry.dropped_samples = item.value("dropped_samples", 0);
            entry.group_size      = item.value("group_size", 5);
            entry.allow_backspace = item.value("allow_backspace", true);

            if (item.contains("top_errors") && item["top_errors"].is_array()) {
                for (const auto& te : item["top_errors"]) {
                    std::string key_str = te.value("key", "");
                    if (!key_str.empty()) {
                        entry.top_errors.push_back({key_str[0], te.value("errors", 0)});
                    }
                }
            }

            result.push_back(entry);
        }
    } catch (...) {}

    return result;
}

// ──────────────────────────────────────────────
// 从 SessionStats 和 Config 创建 HistoryEntry
// ──────────────────────────────────────────────
HistoryEntry HistoryManager::from_stats(
    const SessionStats& stats,
    const Config& config)
{
    HistoryEntry entry;
    entry.timestamp       = current_timestamp();
    entry.mode            = (config.mode == PracticeMode::WORDLIST) ? "wordlist" : "random";
    entry.total_chars     = stats.total_chars;
    entry.accuracy        = stats.accuracy;
    entry.cpm             = stats.cpm;
    entry.duration_secs   = stats.duration_secs;
    entry.dropped_samples = stats.dropped_samples;
    entry.group_size      = config.group_size;
    entry.allow_backspace = config.allow_backspace;

    // top 5 错误
    for (size_t i = 0; i < stats.sorted_by_error.size() && i < 5; ++i) {
        entry.top_errors.push_back({
            stats.sorted_by_error[i].key,
            stats.sorted_by_error[i].error_count
        });
    }

    return entry;
}
