#ifndef DVORAK_PRACTICE_WORDLIST_H
#define DVORAK_PRACTICE_WORDLIST_H

#include <string>
#include <vector>
#include <set>

// ──────────────────────────────────────────────
// 词库文件信息
// ──────────────────────────────────────────────
struct WordlistInfo {
    std::string filename;      // 文件名（不含路径）
    std::string full_path;     // 完整路径
    int word_count;            // 总单词数
    int avg_word_length;       // 平均词长
};

// ──────────────────────────────────────────────
// 词库加载结果
// ──────────────────────────────────────────────
struct WordlistLoadResult {
    bool success;
    std::string error_msg;
    std::vector<std::string> words; // 加载的所有单词
};

// ──────────────────────────────────────────────
// 词库管理器
// ──────────────────────────────────────────────
class WordListManager {
public:
    // 扫描词库目录，返回所有可用词库文件
    static std::vector<WordlistInfo> list_available();

    // 加载指定词库文件
    static WordlistLoadResult load(const std::string& path);

    // 从词库中过滤出只包含指定字符集的单词
    static std::vector<std::string> filter_by_charset(
        const std::vector<std::string>& words,
        const std::set<char>& allowed_chars);
};

#endif // DVORAK_PRACTICE_WORDLIST_H
