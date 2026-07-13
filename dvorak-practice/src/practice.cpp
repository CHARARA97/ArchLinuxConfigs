#include "practice.h"
#include <random>
#include <algorithm>
#include <cctype>

// ──────────────────────────────────────────────
// 构造: 接收配置和词库（可选）
// ──────────────────────────────────────────────
PracticeEngine::PracticeEngine(const Config& config,
    const std::vector<std::string>& wordlist_words)
    : mode_(config.mode)
    , selected_chars_(config.selected_chars)
    , group_size_(config.group_size)
    , total_chars_(config.total_chars)
    , allow_backspace_(config.allow_backspace)
{
    if (mode_ == PracticeMode::RANDOM) {
        generate_random_sequence();
    } else {
        valid_words_ = wordlist_words;
        generate_wordlist_sequence();
    }

    // 启动第一个字符的计时器
    start_char_timer();
}

// ──────────────────────────────────────────────
// 随机模式: 生成 "词 + 空格" 序列
// 每个词由 group_size 个随机字符组成
// ──────────────────────────────────────────────
void PracticeEngine::generate_random_sequence()
{
    targets_.clear();

    // 检查字符集
    if (selected_chars_.empty()) return;

    std::vector<char> chars(selected_chars_.begin(), selected_chars_.end());
    std::mt19937 rng(std::random_device{}());
    std::uniform_int_distribution<size_t> dist(0, chars.size() - 1);

    int chars_generated = 0;

    while (chars_generated < total_chars_) {
        // 生成一个词: group_size 个随机字符
        for (int i = 0; i < group_size_; ++i) {
            if (chars_generated >= total_chars_) break;
            char c = chars[dist(rng)];
            targets_.push_back(c);
            chars_generated++;
        }

        // 词后加空格（除非已达总量）
        if (chars_generated < total_chars_) {
            targets_.push_back(' ');
            chars_generated++;
        }
    }

    // 移除末尾可能多余的空格
    while (!targets_.empty() && targets_.back() == ' ') {
        targets_.pop_back();
    }

    // 重置 slots
    slots_.assign(targets_.size(), CharStatSlot{});
    pos_ = 0;
}

// ──────────────────────────────────────────────
// 词库模式: 从 valid_words_ 中随机抽取词
// ──────────────────────────────────────────────
void PracticeEngine::generate_wordlist_sequence()
{
    targets_.clear();

    if (valid_words_.empty()) {
        // 回退: 生成一些基本字符
        std::set<char> fallback = {'a', 'e', 'i', 'o', 'u', 't', 'n', 's', ' '};
        selected_chars_ = fallback;
        mode_ = PracticeMode::RANDOM;
        generate_random_sequence();
        return;
    }

    std::mt19937 rng(std::random_device{}());
    std::uniform_int_distribution<size_t> dist(0, valid_words_.size() - 1);

    int chars_generated = 0;

    while (chars_generated < total_chars_) {
        const std::string& word = valid_words_[dist(rng)];

        // 追加这个词的所有字符
        for (char c : word) {
            if (chars_generated >= total_chars_) break;
            targets_.push_back(c);
            chars_generated++;
        }

        // 词后加空格
        if (chars_generated < total_chars_) {
            targets_.push_back(' ');
            chars_generated++;
        }
    }

    // 移除末尾多余空格
    while (!targets_.empty() && targets_.back() == ' ') {
        targets_.pop_back();
    }

    slots_.assign(targets_.size(), CharStatSlot{});
    pos_ = 0;
}

// ──────────────────────────────────────────────
// 输入处理核心（每按一键都前进，打错标记为错误并继续）
// ──────────────────────────────────────────────
InputResult PracticeEngine::process_input(char ch)
{
    if (finished_) return {InputResult::Type::FINISHED, false};

    // 首次按键：开始计时
    if (!started_) {
        started_ = true;
        session_start_ = std::chrono::steady_clock::now();
        char_timer_start_ = session_start_;
    }

    if (pos_ >= static_cast<int>(targets_.size())) {
        finished_ = true;
        return {InputResult::Type::FINISHED, false};
    }

    char expected = targets_[pos_];
    bool correct = (ch == expected);
    attempts_++;

    // 记录耗时（从成为候打到输入任何字符）
    double elapsed = -1.0;
    if (char_timer_start_.time_since_epoch().count() > 0) {
        auto now = std::chrono::steady_clock::now();
        elapsed = std::chrono::duration<double>(now - char_timer_start_).count();
    }

    // 填充统计槽
    slots_[pos_].is_answered = true;
    slots_[pos_].is_correct = correct;
    slots_[pos_].final_input = ch;

    if (correct) {
        correct_count_++;
        if (elapsed >= 0.0 && elapsed <= 5.0) {
            slots_[pos_].reaction_time = elapsed;
        } else if (elapsed > 5.0) {
            slots_[pos_].reaction_time = elapsed;
            slots_[pos_].time_dropped = true;
            dropped_samples_++;
        }
    } else {
        slots_[pos_].wrong_inputs.push_back(ch);
        slots_[pos_].has_wrong_attempt = true;
        // 错误不计时，但仍记录尝试
    }

    // ★ 始终前进光标
    pos_++;

    // 检查是否完成
    if (pos_ >= static_cast<int>(targets_.size())) {
        finished_ = true;
        return {InputResult::Type::FINISHED, correct};
    }

    // 启动下一个字符的计时
    char_timer_start_ = std::chrono::steady_clock::now();

    return {InputResult::Type::CHAR_INPUT, correct};
}

// ──────────────────────────────────────────────
// 退格处理
// ──────────────────────────────────────────────
InputResult PracticeEngine::process_backspace()
{
    if (!allow_backspace_ || pos_ <= 0) {
        return {InputResult::Type::IGNORED, false};
    }

    pos_--;
    slots_[pos_] = CharStatSlot{};  // 重置

    // 重新开始当前字符的计时
    char_timer_start_ = std::chrono::steady_clock::now();

    return {InputResult::Type::BACKSPACE, false};
}

// ──────────────────────────────────────────────
// 重置：重新生成序列
// ──────────────────────────────────────────────
InputResult PracticeEngine::process_reset()
{
    // 重新生成
    if (mode_ == PracticeMode::RANDOM) {
        generate_random_sequence();
    } else {
        generate_wordlist_sequence();
    }

    // 重置全部状态
    started_ = false;
    finished_ = false;
    attempts_ = 0;
    correct_count_ = 0;
    dropped_samples_ = 0;
    total_pause_duration_ = std::chrono::duration<double>::zero();

    start_char_timer();

    return {InputResult::Type::RESET, false};
}

// ──────────────────────────────────────────────
// 暂停/恢复
// ──────────────────────────────────────────────
void PracticeEngine::pause()
{
    if (paused_) return;
    paused_ = true;
    pause_start_ = std::chrono::steady_clock::now();
}

void PracticeEngine::resume()
{
    if (!paused_) return;
    paused_ = false;

    // 累计暂停时间
    auto now = std::chrono::steady_clock::now();
    total_pause_duration_ += (now - pause_start_);
}

bool PracticeEngine::is_paused() const
{
    return paused_;
}

// ──────────────────────────────────────────────
// 状态查询
// ──────────────────────────────────────────────
int PracticeEngine::get_pos() const { return pos_; }
int PracticeEngine::get_total() const { return static_cast<int>(targets_.size()); }
const std::vector<char>& PracticeEngine::get_targets() const { return targets_; }
const std::vector<CharStatSlot>& PracticeEngine::get_slots() const { return slots_; }
bool PracticeEngine::is_finished() const { return finished_; }

char PracticeEngine::get_current_target() const
{
    if (pos_ < static_cast<int>(targets_.size())) {
        return targets_[pos_];
    }
    return '\0';
}

// ──────────────────────────────────────────────
// 统计
// ──────────────────────────────────────────────
int PracticeEngine::get_correct_count() const { return correct_count_; }

int PracticeEngine::get_error_count() const
{
    // 统计有错误输入的已答字符
    int errors = 0;
    for (int i = 0; i < pos_; ++i) {
        if (!slots_[i].is_correct) errors++;
    }
    return errors;
}

int PracticeEngine::get_attempts() const { return attempts_; }

double PracticeEngine::get_accuracy() const
{
    if (pos_ == 0) return 0.0;
    return static_cast<double>(correct_count_) / pos_;
}

double PracticeEngine::get_cpm() const
{
    double secs = get_elapsed_seconds();
    if (secs < 1.0) return 0.0;
    return (correct_count_ / secs) * 60.0;
}

double PracticeEngine::get_elapsed_seconds() const
{
    if (!started_) return 0.0;
    auto now = std::chrono::steady_clock::now();
    double total = std::chrono::duration<double>(now - session_start_).count();
    total -= total_pause_duration_.count();
    if (paused_) {
        total -= std::chrono::duration<double>(now - pause_start_).count();
    }
    return total;
}

int PracticeEngine::get_dropped_samples() const { return dropped_samples_; }

int PracticeEngine::get_current_word() const
{
    // 统计当前光标前有多少个空格（即第几个词）
    int words = 0;
    for (int i = 0; i < pos_ && i < static_cast<int>(targets_.size()); ++i) {
        if (targets_[i] == ' ') words++;
    }
    return words + 1;
}

int PracticeEngine::get_total_words() const
{
    // 统计总共有多少词（空格数+1或1）
    int words = 1;
    for (char c : targets_) {
        if (c == ' ') words++;
    }
    return words;
}

double PracticeEngine::get_current_target_time() const
{
    if (!started_ || pos_ >= static_cast<int>(targets_.size())) {
        return 0.0;
    }
    if (char_timer_start_.time_since_epoch().count() == 0) {
        return 0.0;
    }
    auto now = std::chrono::steady_clock::now();
    return std::chrono::duration<double>(now - char_timer_start_).count();
}

// ──────────────────────────────────────────────
// 计时器管理
// ──────────────────────────────────────────────
void PracticeEngine::start_char_timer()
{
    char_timer_start_ = std::chrono::steady_clock::now();
}

void PracticeEngine::stop_char_timer()
{
    // 计时已经在 process_input 中通过时间差计算
    // 这里只重置为"已启动"状态
}
