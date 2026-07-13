#ifndef DVORAK_PRACTICE_HISTORY_H
#define DVORAK_PRACTICE_HISTORY_H

#include "config.h"
#include "statistics.h"
#include <string>
#include <vector>
#include <chrono>

// ──────────────────────────────────────────────
// 单次历史记录条目
// ──────────────────────────────────────────────
struct HistoryEntry {
    std::string timestamp;                  // ISO 8601
    std::string mode;                       // "random" or "wordlist"
    int total_chars = 0;
    double accuracy = 0.0;
    double cpm = 0.0;
    double duration_secs = 0.0;
    int dropped_samples = 0;
    std::vector<std::pair<char, int>> top_errors;  // top 5
    int group_size = 5;
    bool allow_backspace = true;
};

// ──────────────────────────────────────────────
// 历史管理器
// ──────────────────────────────────────────────
class HistoryManager {
public:
    static void append(const HistoryEntry& entry);
    static std::vector<HistoryEntry> load();

    // 从 SessionStats 和 Config 创建 HistoryEntry
    static HistoryEntry from_stats(
        const SessionStats& stats,
        const Config& config);
};

#endif // DVORAK_PRACTICE_HISTORY_H
