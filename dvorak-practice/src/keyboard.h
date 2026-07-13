#ifndef DVORAK_PRACTICE_KEYBOARD_H
#define DVORAK_PRACTICE_KEYBOARD_H

#include <string>
#include <vector>
#include <unordered_map>
#include <set>

// ──────────────────────────────────────────────
// 键盘上每个字符在绘制时的定位信息
// ──────────────────────────────────────────────
struct KeyPos {
    int row;          // 0~3，对应 R1~R4
    int col;          // 该行中第几个键格（从0开始）
    int str_index;    // 在行模板字符串中的字符索引（用于 mvwchgat）
};

// ──────────────────────────────────────────────
// 键盘上的一个完整键格
// ──────────────────────────────────────────────
struct KeyCell {
    char lower;       // 无Shift层字符
    char upper;       // 按Shift时字符
    bool is_modifier; // 是否是修饰键（Tab/Ctrl/Shift/Enter/<--/Space等）
    int row;          // 0~3
    int col;          // 该行中第几个键格
    int str_index;    // 在行模板中的位置
};

// ──────────────────────────────────────────────
// 预设键集定义
// ──────────────────────────────────────────────
struct KeySetDef {
    std::string name;
    std::string chars; // 包含的字符集合（小写字母和符号）
};

// ──────────────────────────────────────────────
// 键盘布局类（全部静态，无状态）
// ──────────────────────────────────────────────
class KeyboardLayout {
public:
    // ── 键盘模板（4行内容行，用于解析字符位置）──
    static const std::vector<std::string>& row_templates();

    // ── 完整键盘显示行（9行，含边框/分隔线/内容行/底边）──
    static const std::vector<std::string>& full_display_lines();

    // ── 字符 → 键位位置（O(1) 查找） ──
    // 返回 nullptr 如果字符不在可练习映射中
    static const KeyPos* find_char_pos(char c);

    // ── 字符 → 完整键格信息 ──
    static const KeyCell* find_key_cell(char c);

    // ── 获取所有键格（用于渲染整盘键盘）──
    static const std::vector<KeyCell>& all_cells();

    // ── 预设键集 ──
    static const std::vector<KeySetDef>& preset_key_sets();

    // ── 获取所有可练习字符的完整集合 ──
    static std::string all_practiceable_chars();

    // ── 验证 ──
    static bool is_practiceable(char c);

    // ── 空格键（不在4行键盘图中） ──
    static bool is_space(char c);
    // 空格在键盘上没有固定键格，标记为 -1
    static constexpr int SPACE_ROW = -1;
    static constexpr int SPACE_COL = -1;

private:
    // 内部初始化（一次构建，静态缓存）
    static void init_maps();

    static bool initialized_;
    static std::unordered_map<char, KeyPos> char_map_;
    static std::unordered_map<char, KeyCell> cell_map_;
    static std::vector<KeyCell> all_cells_;
    static std::vector<std::string> templates_;
    static std::vector<std::string> templates_full_;
    static std::vector<KeySetDef> presets_;
};

#endif // DVORAK_PRACTICE_KEYBOARD_H
