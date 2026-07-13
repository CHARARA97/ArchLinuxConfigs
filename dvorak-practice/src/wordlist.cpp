#include "wordlist.h"
#include "config.h"
#include <fstream>
#include <iostream>
#include <filesystem>
#include <algorithm>
#include <cctype>

namespace fs = std::filesystem;

// ──────────────────────────────────────────────
// 列出所有可用词库
// ──────────────────────────────────────────────
std::vector<WordlistInfo> WordListManager::list_available()
{
    std::vector<WordlistInfo> result;
    std::string dir_path = ConfigManager::get_wordlist_dir();

    if (!fs::exists(dir_path)) {
        return result;
    }

    for (const auto& entry : fs::directory_iterator(dir_path)) {
        if (entry.is_regular_file()) {
            std::string ext = entry.path().extension().string();
            if (ext == ".txt" || ext == ".words") {
                WordlistInfo info;
                info.filename   = entry.path().filename().string();
                info.full_path  = entry.path().string();
                // 粗略统计: 行数 = 单词数
                std::ifstream fin(info.full_path);
                std::string line;
                int lines = 0;
                int total_len = 0;
                while (std::getline(fin, line)) {
                    // 跳过空行和注释
                    if (line.empty() || line[0] == '#') continue;
                    // 去除首尾空白
                    auto start = line.find_first_not_of(" \t\r");
                    if (start == std::string::npos) continue;
                    auto end = line.find_last_not_of(" \t\r");
                    line = line.substr(start, end - start + 1);
                    if (line.empty()) continue;
                    lines++;
                    total_len += static_cast<int>(line.size());
                }
                info.word_count = lines;
                info.avg_word_length = (lines > 0) ? (total_len / lines) : 0;
                result.push_back(info);
            }
        }
    }

    // 按文件名排序
    std::sort(result.begin(), result.end(),
        [](const WordlistInfo& a, const WordlistInfo& b) {
            return a.filename < b.filename;
        });

    return result;
}

// ──────────────────────────────────────────────
// 加载词库文件
// ──────────────────────────────────────────────
WordlistLoadResult WordListManager::load(const std::string& path)
{
    WordlistLoadResult result;
    result.success = false;

    std::ifstream fin(path);
    if (!fin.good()) {
        result.error_msg = "无法打开词库文件: " + path;
        return result;
    }

    std::string line;
    while (std::getline(fin, line)) {
        // 去除首尾空白
        auto start = line.find_first_not_of(" \t\r\n");
        if (start == std::string::npos) continue;
        auto end = line.find_last_not_of(" \t\r\n");
        line = line.substr(start, end - start + 1);

        // 跳过注释(以#开头)和空行
        if (line.empty() || line[0] == '#') continue;

        result.words.push_back(line);
    }

    if (result.words.empty()) {
        result.error_msg = "词库文件为空或格式不正确: " + path;
        return result;
    }

    result.success = true;
    return result;
}

// ──────────────────────────────────────────────
// 过滤词库: 只保留全部字符都在 allowed_chars 中的单词
// ──────────────────────────────────────────────
std::vector<std::string> WordListManager::filter_by_charset(
    const std::vector<std::string>& words,
    const std::set<char>& allowed_chars)
{
    std::vector<std::string> result;
    result.reserve(words.size());

    for (const auto& word : words) {
        bool ok = true;
        for (char c : word) {
            // 转为小写比较（因为词库中的大写字母视为小写）
            char lower_c = static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
            if (allowed_chars.find(lower_c) == allowed_chars.end()) {
                // 注意：词库中的单词可能包含大写字母
                // 但我们的练习集合只包含小写字母和符号
                // 所以应该把小写版本也检查一下
                if (allowed_chars.find(c) == allowed_chars.end()) {
                    ok = false;
                    break;
                }
            }
        }
        if (ok) {
            result.push_back(word);
        }
    }

    return result;
}
