#include "statistics.h"
#include <algorithm>
#include <unordered_map>

// ──────────────────────────────────────────────
// 按键位聚合原始数据
// ──────────────────────────────────────────────
std::unordered_map<char, KeyStats> StatisticsCalculator::aggregate_by_key(
    const std::vector<char>& targets,
    const std::vector<CharStatSlot>& slots)
{
    std::unordered_map<char, KeyStats> map;

    size_t n = std::min(targets.size(), slots.size());
    for (size_t i = 0; i < n; ++i) {
        char key = targets[i];
        auto& ks = map[key];
        ks.key = key;
        ks.occurrences++;

        if (slots[i].is_answered) {
            if (slots[i].is_correct) {
                ks.correct_count++;
            } else {
                ks.error_count++;
            }

            // 记录耗时
            if (slots[i].reaction_time >= 0.0 && !slots[i].time_dropped) {
                ks.avg_reaction_time += slots[i].reaction_time;
                ks.valid_time_samples++;
            }

            // 收集常错字符
            for (char wrong : slots[i].wrong_inputs) {
                auto it = std::find_if(ks.misstrokes.begin(), ks.misstrokes.end(),
                    [wrong](const std::pair<char, int>& p) { return p.first == wrong; });
                if (it != ks.misstrokes.end()) {
                    it->second++;
                } else {
                    ks.misstrokes.push_back({wrong, 1});
                }
            }
        }
        // 注意: 对于退格后重打的字符，is_answered 会为 true 只记录最后一次的输入
        // 但 wrong_inputs 中保留了所有历史错误
    }

    // 计算平均值和排序错字符
    for (auto& [_, ks] : map) {
        if (ks.occurrences > 0) {
            ks.accuracy = static_cast<double>(ks.correct_count) / ks.occurrences;
        }
        if (ks.valid_time_samples > 0) {
            ks.avg_reaction_time /= ks.valid_time_samples;
        }
        // 错字符按次数降序排序
        std::sort(ks.misstrokes.begin(), ks.misstrokes.end(),
            [](const auto& a, const auto& b) { return a.second > b.second; });
    }

    return map;
}

// ──────────────────────────────────────────────
// 计算完整统计
// ──────────────────────────────────────────────
SessionStats StatisticsCalculator::calculate(
    const std::vector<char>& targets,
    const std::vector<CharStatSlot>& slots,
    double elapsed_seconds,
    int attempts,
    int dropped_samples)
{
    SessionStats stats;
    stats.total_chars = static_cast<int>(targets.size());
    stats.dropped_samples = dropped_samples;
    stats.duration_secs = elapsed_seconds;

    // 计算总体
    for (const auto& s : slots) {
        if (s.is_answered) {
            if (s.is_correct) {
                stats.correct_count++;
            } else {
                stats.error_count++;
            }
        }
    }
    stats.accuracy = (stats.total_chars > 0)
        ? static_cast<double>(stats.correct_count) / stats.total_chars
        : 0.0;
    stats.cpm = (elapsed_seconds > 0)
        ? (stats.correct_count / elapsed_seconds) * 60.0
        : 0.0;

    // 聚合
    auto by_key = aggregate_by_key(targets, slots);

    // 按错误数排序
    stats.sorted_by_error.reserve(by_key.size());
    for (const auto& [_, ks] : by_key) {
        if (ks.error_count > 0) {
            stats.sorted_by_error.push_back(ks);
        }
    }
    std::sort(stats.sorted_by_error.begin(), stats.sorted_by_error.end(),
        [](const KeyStats& a, const KeyStats& b) { return a.error_count > b.error_count; });

    // 按耗时排序（只要有 valid_time_samples 就加入）
    stats.sorted_by_time.reserve(by_key.size());
    for (const auto& [_, ks] : by_key) {
        if (ks.valid_time_samples > 0 && ks.avg_reaction_time > 0) {
            stats.sorted_by_time.push_back(ks);
        }
    }
    std::sort(stats.sorted_by_time.begin(), stats.sorted_by_time.end(),
        [](const KeyStats& a, const KeyStats& b) { return a.avg_reaction_time > b.avg_reaction_time; });

    return stats;
}
