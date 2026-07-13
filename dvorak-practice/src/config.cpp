#include "config.h"
#include "keyboard.h"
#include <nlohmann/json.hpp>
#include <fstream>
#include <iostream>
#include <cstdlib>
#include <sys/stat.h>
#include <unistd.h>
#include <pwd.h>

using json = nlohmann::json;

// ──────────────────────────────────────────────
// 工具函数: 获取 home 目录
// ──────────────────────────────────────────────
static std::string home_dir()
{
    const char* home = std::getenv("HOME");
    if (home) return home;
    struct passwd* pw = getpwuid(getuid());
    if (pw) return pw->pw_dir;
    return "/tmp";
}

// ──────────────────────────────────────────────
// 路径工具
// ──────────────────────────────────────────────
std::string ConfigManager::get_config_dir()
{
    return home_dir() + "/.dvorak_practice";
}

std::string ConfigManager::get_config_path()
{
    return get_config_dir() + "/config.json";
}

std::string ConfigManager::get_wordlist_dir()
{
    return get_config_dir() + "/wordlists";
}

std::string ConfigManager::get_history_path()
{
    return get_config_dir() + "/history.json";
}

void ConfigManager::ensure_dirs()
{
    std::string dir = get_config_dir();
    mkdir(dir.c_str(), 0755);
    mkdir(get_wordlist_dir().c_str(), 0755);
}

// ──────────────────────────────────────────────
// 默认配置
// ──────────────────────────────────────────────
Config ConfigManager::default_config()
{
    Config cfg;
    cfg.mode = PracticeMode::RANDOM;
    cfg.selected_preset_names = {"字母全"};
    cfg.custom_chars = "";
    cfg.group_size = 5;
    cfg.total_chars = 200;
    cfg.allow_backspace = true;
    cfg.wordlist_path = "";
    cfg.selected_chars = merge_key_sets(cfg.selected_preset_names, cfg.custom_chars);
    return cfg;
}

// ──────────────────────────────────────────────
// 合并键集: 预设名称 → 字符集合
// ──────────────────────────────────────────────
std::set<char> ConfigManager::merge_key_sets(
    const std::vector<std::string>& preset_names,
    const std::string& custom_chars)
{
    std::set<char> result;

    // 预设名称 → 字符集 查找表
    const auto& presets = KeyboardLayout::preset_key_sets();
    for (const auto& name : preset_names) {
        for (const auto& ps : presets) {
            if (ps.name == name) {
                for (char c : ps.chars) {
                    result.insert(c);
                }
                break;
            }
        }
    }

    // 加入自定义字符（空格由生成器自动添加，不纳入字符集）
    for (char c : custom_chars) {
        if (c != ' ' && KeyboardLayout::is_practiceable(c)) {
            result.insert(c);
        }
    }

    return result;
}

// ──────────────────────────────────────────────
// 配置校验
// ──────────────────────────────────────────────
bool Config::is_valid() const
{
    return validation_error().empty();
}

std::string Config::validation_error() const
{
    if (selected_chars.empty()) {
        return "错误: 未选择任何练习字符。请至少选择一个键集。";
    }
    if (group_size < 1 || group_size > 100) {
        return "错误: 词长(组大小)必须在 1~100 之间。";
    }
    if (total_chars < 1 || total_chars > 100000) {
        return "错误: 练习总量必须在 1~100000 之间。";
    }
    return "";
}

// ──────────────────────────────────────────────
// JSON 序列化/反序列化
// ──────────────────────────────────────────────
Config ConfigManager::load()
{
    ensure_dirs();

    std::string path = get_config_path();
    std::ifstream fin(path);
    if (!fin.good()) {
        // 文件不存在, 创建默认配置并保存
        Config def = default_config();
        save(def);
        return def;
    }

    try {
        json j;
        fin >> j;

        Config cfg;

        std::string mode_str = j.value("mode", "random");
        cfg.mode = (mode_str == "wordlist") ? PracticeMode::WORDLIST : PracticeMode::RANDOM;

        // 预设名称列表
        if (j.contains("selected_presets") && j["selected_presets"].is_array()) {
            for (const auto& p : j["selected_presets"]) {
                cfg.selected_preset_names.push_back(p.get<std::string>());
            }
        } else {
            cfg.selected_preset_names = {"字母全"};
        }

        cfg.custom_chars = j.value("custom_chars", "");
        cfg.group_size   = j.value("group_size", 5);
        cfg.total_chars  = j.value("total_chars", 200);
        cfg.allow_backspace = j.value("allow_backspace", true);
        cfg.wordlist_path = j.value("wordlist_path", "");

        // 重新计算选中的字符集
        cfg.selected_chars = merge_key_sets(cfg.selected_preset_names, cfg.custom_chars);

        return cfg;
    } catch (const std::exception& e) {
        // JSON 解析失败, 回退到默认
        Config def = default_config();
        save(def);
        return def;
    }
}

void ConfigManager::save(const Config& config)
{
    ensure_dirs();

    json j;
    j["version"] = 1;
    j["mode"] = (config.mode == PracticeMode::WORDLIST) ? "wordlist" : "random";

    // 预设名称列表
    j["selected_presets"] = config.selected_preset_names;
    j["custom_chars"]     = config.custom_chars;
    j["group_size"]       = config.group_size;
    j["total_chars"]      = config.total_chars;
    j["allow_backspace"]  = config.allow_backspace;
    j["wordlist_path"]    = config.wordlist_path;

    std::ofstream fout(get_config_path());
    fout << j.dump(4) << std::endl;
}
