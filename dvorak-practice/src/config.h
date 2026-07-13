#ifndef DVORAK_PRACTICE_CONFIG_H
#define DVORAK_PRACTICE_CONFIG_H

#include <string>
#include <vector>
#include <set>

// ──────────────────────────────────────────────
// 练习模式
// ──────────────────────────────────────────────
enum class PracticeMode {
    RANDOM,    // 随机字符模式
    WORDLIST,  // 词库模式
};

// ──────────────────────────────────────────────
// 完整配置结构体
// ──────────────────────────────────────────────
struct Config {
    PracticeMode mode = PracticeMode::RANDOM;

    // 键集
    std::set<char> selected_chars;     // 最终选中的可练习字符集合（去重后）
    std::vector<std::string> selected_preset_names; // 选中的预设名称列表
    std::string custom_chars;          // 自定义字符

    // 数值
    int group_size   = 5;     // 随机模式: 每个"词"的字符数; 词库模式: 忽略
    int total_chars  = 200;   // 练习总字符数

    // 开关
    bool allow_backspace = true;

    // 词库
    std::string wordlist_path;  // 词库文件路径（仅 wordlist 模式使用）
    std::vector<std::string> wordlist_words; // 加载到内存的词库内容

    // ── 验证 ──
    bool is_valid() const;
    std::string validation_error() const;
};

// ──────────────────────────────────────────────
// 配置管理器
// ──────────────────────────────────────────────
class ConfigManager {
public:
    static std::string get_config_dir();
    static std::string get_config_path();
    static std::string get_wordlist_dir();
    static std::string get_history_path();

    // 加载配置（如果文件不存在则创建默认配置并返回）
    static Config load();

    // 保存配置
    static void save(const Config& config);

    // 创建默认配置
    static Config default_config();

    // 从预设名称列表 + 自定义字符串 → 合并为做种后的字符集合
    static std::set<char> merge_key_sets(
        const std::vector<std::string>& preset_names,
        const std::string& custom_chars
    );

    // 确保配置目录存在
    static void ensure_dirs();
};

#endif // DVORAK_PRACTICE_CONFIG_H
