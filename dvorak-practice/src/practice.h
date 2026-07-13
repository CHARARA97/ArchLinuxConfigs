#ifndef DVORAK_PRACTICE_PRACTICE_H
#define DVORAK_PRACTICE_PRACTICE_H

#include "config.h"
#include "keyboard.h"
#include <vector>
#include <string>
#include <chrono>
#include <set>

// ──────────────────────────────────────────────
// 每个字符的统计槽
// ──────────────────────────────────────────────
struct CharStatSlot {
    bool is_answered = false;          // 是否已被正确输入
    bool is_correct = false;           // 第一次是否正确（用于颜色显示）
    bool has_wrong_attempt = false;    // 当前字符是否被打错过（用于渲染红色提示）
    std::vector<char> wrong_inputs;    // 所有错误输入
    char final_input = '\0';           // 最终正确的输入
    double reaction_time = -1.0;       // 正确输入耗时(s)，-1=未记录
    bool time_dropped = false;         // 是否因超5s被丢弃
};

// ──────────────────────────────────────────────
// 输入处理结果
// ──────────────────────────────────────────────
struct InputResult {
    enum class Type {
        CHAR_INPUT,    // 普通字符输入
        BACKSPACE,     // 退格
        RESET,         // 重置
        EXIT,          // 退出
        FINISHED,      // 练习完成
        IGNORED,       // 无效输入
    };
    Type type;
    bool is_correct = false;
};

// ──────────────────────────────────────────────
// 练习引擎
// ──────────────────────────────────────────────
class PracticeEngine {
public:
    PracticeEngine(const Config& config,
                   const std::vector<std::string>& wordlist_words = {});

    // ── 核心输入处理 ──
    InputResult process_input(char ch);
    InputResult process_backspace();
    InputResult process_reset();  // 重新生成序列

    // ── 暂停/恢复 ──
    void pause();
    void resume();
    bool is_paused() const;

    // ── 状态查询（只读） ──
    int get_pos() const;
    int get_total() const;
    const std::vector<char>& get_targets() const;
    const std::vector<CharStatSlot>& get_slots() const;
    char get_current_target() const;
    bool is_finished() const;

    // ── 实时统计 ──
    int get_correct_count() const;
    int get_error_count() const;
    int get_attempts() const;
    double get_accuracy() const;              // 0.0 ~ 1.0
    double get_cpm() const;                   // 每分钟字符数
    double get_elapsed_seconds() const;       // 排除暂停时间
    int get_dropped_samples() const;
    int get_current_word() const;             // 当前是第几个词
    int get_total_words() const;
    double get_current_target_time() const;   // 当前候打字符的已用(s)

private:
    // 序列生成
    void generate_random_sequence();
    void generate_wordlist_sequence();

    // 计时
    void start_char_timer();
    void stop_char_timer();

    // 内部状态
    std::vector<char> targets_;
    std::vector<CharStatSlot> slots_;
    int pos_ = 0;
    bool started_ = false;
    bool finished_ = false;
    bool paused_ = false;

    // 配置
    PracticeMode mode_;
    std::set<char> selected_chars_;
    int group_size_;
    int total_chars_;
    bool allow_backspace_;

    // 词库相关（仅词库模式）
    std::vector<std::string> valid_words_;

    // 统计计数
    int attempts_ = 0;
    int correct_count_ = 0;
    int dropped_samples_ = 0;

    // 计时
    std::chrono::steady_clock::time_point char_timer_start_;
    std::chrono::steady_clock::time_point session_start_;
    std::chrono::steady_clock::time_point pause_start_;
    std::chrono::duration<double> total_pause_duration_{0};
};

#endif // DVORAK_PRACTICE_PRACTICE_H
