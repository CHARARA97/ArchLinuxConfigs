#ifndef DVORAK_PRACTICE_STATISTICS_H
#define DVORAK_PRACTICE_STATISTICS_H

#include "practice.h"
#include <vector>
#include <string>
#include <unordered_map>

// ──────────────────────────────────────────────
// 单个键位的详细统计
// ──────────────────────────────────────────────
struct KeyStats {
    char key = '\0';
    int occurrences = 0;                // 在目标序列中出现次数
    int correct_count = 0;
    int error_count = 0;
    double accuracy = 0.0;              // 0.0~1.0
    std::vector<std::pair<char, int>> misstrokes; // 常错成的字符, 按次数排序
    double avg_reaction_time = 0.0;     // 平均耗时（仅有效样本）
    int valid_time_samples = 0;         // 有效耗时样本数
};

// ──────────────────────────────────────────────
// 完整会话统计
// ──────────────────────────────────────────────
struct SessionStats {
    int total_chars = 0;
    int correct_count = 0;
    int error_count = 0;
    double accuracy = 0.0;
    double cpm = 0.0;
    double duration_secs = 0.0;
    int dropped_samples = 0;

    // 按错误数从高到低排列
    std::vector<KeyStats> sorted_by_error;
    // 按平均耗时从高到低排列
    std::vector<KeyStats> sorted_by_time;
};

// ──────────────────────────────────────────────
// 统计计算器
// ──────────────────────────────────────────────
class StatisticsCalculator {
public:
    static SessionStats calculate(
        const std::vector<char>& targets,
        const std::vector<CharStatSlot>& slots,
        double elapsed_seconds,
        int attempts,
        int dropped_samples
    );

private:
    static std::unordered_map<char, KeyStats> aggregate_by_key(
        const std::vector<char>& targets,
        const std::vector<CharStatSlot>& slots
    );
};

#endif // DVORAK_PRACTICE_STATISTICS_H
