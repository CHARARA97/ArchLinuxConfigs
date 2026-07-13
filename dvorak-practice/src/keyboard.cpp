#include "keyboard.h"
#include <algorithm>
#include <cctype>
#include <cstring>

// ──────────────────────────────────────────────
// 静态成员初始化
// ──────────────────────────────────────────────
bool KeyboardLayout::initialized_ = false;
std::unordered_map<char, KeyPos> KeyboardLayout::char_map_;
std::unordered_map<char, KeyCell> KeyboardLayout::cell_map_;
std::vector<KeyCell> KeyboardLayout::all_cells_;
std::vector<std::string> KeyboardLayout::templates_;
std::vector<std::string> KeyboardLayout::templates_full_;
std::vector<KeySetDef> KeyboardLayout::presets_;

// UTF-8 字符 '│' (U+2502) 占用 3 字节
static constexpr int PIPE_BYTES = 3;
static const char* PIPE_STR = "\xe2\x94\x82";

// ──────────────────────────────────────────────
// 键盘模板字符串（4行内容行）
// ──────────────────────────────────────────────
static const std::vector<std::string> kFullKeyboard = {
    "┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬──────────┐",
    "│ $~ │ &% │ [7 │ {5 │ }3 │ (1 │ =9 │ *0 │ )2 │ +4 │ ]6 │ !8 │ #` │   Tab    │",
    "├────┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬─────────┤",
    "│ <-- │ ;: │ ,< │ .> │  P │  Y │  F │  G │  C │  R │  L │ /? │ @^ │   \\|    │",
    "├─────┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴─────────┤",
    "│ Ctrl │  A │  O │  E │  U │  I │  D │  H │  T │  N │  S │ -_ │  Enter      │",
    "├──────┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴─────────────┤",
    "│ Shift │ '\" │  Q │  J │  K │  X │  B │  M │  W │  V │  Z │   Shift         │",
    "└───────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴─────────────────┘",
};

static const std::vector<std::string> kRowTemplates = {
    "│ $~ │ &% │ [7 │ {5 │ }3 │ (1 │ =9 │ *0 │ )2 │ +4 │ ]6 │ !8 │ #` │   Tab    │",
    "│ <-- │ ;: │ ,< │ .> │  P │  Y │  F │  G │  C │  R │  L │ /? │ @^ │   \\|    │",
    "│ Ctrl │  A │  O │  E │  U │  I │  D │  H │  T │  N │  S │ -_ │  Enter      │",
    "│ Shift │ '\" │  Q │  J │  K │  X │  B │  M │  W │  V │  Z │   Shift         │",
};

// ──────────────────────────────────────────────
// 解析一行模板，提取所有键格
// ──────────────────────────────────────────────
static bool is_modifier_label(const std::string& label)
{
    static const std::string mods[] = {
        "Tab", "<--", "Ctrl", "Enter", "Shift", "\""
    };
    for (const auto& m : mods) {
        if (label == m) return true;
    }
    return false;
}

// 字节偏移 → 显示列偏移（每字符1列）
static int byte_to_col(const std::string& s, int byte_pos)
{
    int col = 0;
    for (int i = 0; i < byte_pos && i < static_cast<int>(s.size()); ++col) {
        unsigned char c = static_cast<unsigned char>(s[i]);
        if (c < 0x80)      i += 1;
        else if (c < 0xE0) i += 2;
        else               i += 3;
    }
    return col;
}

static void parse_row(int row, const std::string& line,
                      std::vector<KeyCell>& out_cells,
                      std::unordered_map<char, KeyPos>& out_char_map,
                      std::unordered_map<char, KeyCell>& out_cell_map)
{
    size_t pos = 0;
    int col = 0;

    while (pos < line.size()) {
        // 找下一个 '│' (3 字节 UTF-8)
        auto pipe = line.find(PIPE_STR, pos);
        if (pipe == std::string::npos) break;

        // 键格内容起始：跳过 '│' 的 3 字节
        size_t content_start = pipe + PIPE_BYTES;

        // 找下一个 '│'
        auto next_pipe = line.find(PIPE_STR, content_start);
        if (next_pipe == std::string::npos) break;

        // 提取键格内容
        std::string raw = line.substr(content_start, next_pipe - content_start);

        // 去除首尾空格
        auto ts = raw.find_first_not_of(" ");
        auto te = raw.find_last_not_of(" ");
        if (ts == std::string::npos) {
            pos = next_pipe;
            col++;
            continue;
        }
        std::string content = raw.substr(ts, te - ts + 1);

        // 判断是否是修饰键
        bool is_mod = is_modifier_label(content);

        KeyCell cell;
        cell.is_modifier = is_mod;
        cell.row = row;
        cell.col = col;
        cell.str_index = byte_to_col(line, static_cast<int>(content_start + ts));
        cell.lower = '\0';
        cell.upper = '\0';

        if (!is_mod && !content.empty()) {
            if (content.size() >= 2) {
                // 双字符键格: "$~", "&%", "[7", ";:", " /?" → c1=下层, c2=上层
                cell.lower = content[0];
                cell.upper = content[1];
            } else if (content.size() == 1) {
                // 单字符键格: "  P", "  A" → 大写字母是上层，下层的对应小写字母
                char c = content[0];
                if (std::isupper(static_cast<unsigned char>(c))) {
                    cell.lower = static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
                    cell.upper = c;
                } else {
                    cell.lower = c;
                    cell.upper = c; // 相同
                }
            }

            // 加入映射表
            // lower 层字符
            if (cell.lower != '\0') {
                KeyPos kp{row, col, cell.str_index};
                out_char_map[cell.lower] = kp;
                out_cell_map[cell.lower] = cell;
            }
            // upper 层字符（大写字母加入但仅供键盘显示）
            if (cell.upper != '\0' && cell.upper != cell.lower) {
                KeyPos kp{row, col, cell.str_index + 1};
                out_char_map[cell.upper] = kp;
                out_cell_map[cell.upper] = cell;
            }
        }

        out_cells.push_back(cell);
        pos = next_pipe;  // 下一个键格的起始位置是当前 │
        col++;
    }
}

// ──────────────────────────────────────────────
// init_maps()
// ──────────────────────────────────────────────
void KeyboardLayout::init_maps()
{
    if (initialized_) return;

    templates_ = {kRowTemplates[0], kRowTemplates[1], kRowTemplates[2], kRowTemplates[3]};
    templates_full_ = {kFullKeyboard[0], kFullKeyboard[1], kFullKeyboard[2],
                       kFullKeyboard[3], kFullKeyboard[4], kFullKeyboard[5],
                       kFullKeyboard[6], kFullKeyboard[7], kFullKeyboard[8]};

    for (int row = 0; row < 4; ++row) {
        parse_row(row, templates_[row], all_cells_, char_map_, cell_map_);
    }

    presets_ = {
        {"字母全",     "abcdefghijklmnopqrstuvwxyz"},
        {"Home Row",   "aoeuidhtns"},
        {"Top Row",    ";,.pyfgcrl/@\\"},
        {"Bottom Row", "'qjkxbmwvz"},
        {"数字行符号", "$&[{}(=*)+]!#"},
        {"数字行数字", "~%7531902468`"},
        {"全部符号",   "$&[{}(=*)+]!#';:<.>/?@^\\|\"`-"},
        {"程序员常用", "$&[{}(=*)+]!#';:<.>/@\\-\"_`?"},

        // ── 左右手按行（分隔符: 前=左手末, 后=右手首）──
        //   =* : R1 上 `=` 最后左, `*` 最先右
        //   yf : R2 上 `y` 最后左, `f` 最先右
        //   id : R3 上 `i` 最后左, `d` 最先右
        //   xb : R4 上 `x` 最后左, `b` 最先右
        {"R1 左手", "$&[{}(="},
        {"R1 右手", "*)+]!#"},
        {"R2 左手", ";,.py"},
        {"R2 右手", "fgcrl/@\\"},
        {"R3 左手", "aoeui"},
        {"R3 右手", "dhtns-"},
        {"R4 左手", "'qjkx"},
        {"R4 右手", "bmwvz"},

        // ── 左右手全行 ──
        {"左手全行", "$&[{}(=;,.pyaoeui'qjkx"},
        {"右手全行", "*)+]!#fgcrl/@\\dhtns-bmwvz"},
    };

    initialized_ = true;
}

// ──────────────────────────────────────────────
// 公共接口
// ──────────────────────────────────────────────
const std::vector<std::string>& KeyboardLayout::row_templates()
{
    init_maps();
    return templates_;
}

const std::vector<std::string>& KeyboardLayout::full_display_lines()
{
    init_maps();
    return templates_full_;
}

const KeyPos* KeyboardLayout::find_char_pos(char c)
{
    init_maps();
    auto it = char_map_.find(c);
    return (it != char_map_.end()) ? &it->second : nullptr;
}

const KeyCell* KeyboardLayout::find_key_cell(char c)
{
    init_maps();
    auto it = cell_map_.find(c);
    return (it != cell_map_.end()) ? &it->second : nullptr;
}

const std::vector<KeyCell>& KeyboardLayout::all_cells()
{
    init_maps();
    return all_cells_;
}

const std::vector<KeySetDef>& KeyboardLayout::preset_key_sets()
{
    init_maps();
    return presets_;
}

std::string KeyboardLayout::all_practiceable_chars()
{
    init_maps();
    std::string result;
    for (const auto& [ch, _] : char_map_) {
        if (std::isalpha(static_cast<unsigned char>(ch))) {
            if (std::islower(static_cast<unsigned char>(ch))) {
                result.push_back(ch);
            }
        } else {
            result.push_back(ch);
        }
    }
    std::sort(result.begin(), result.end());
    result.erase(std::unique(result.begin(), result.end()), result.end());
    return result;
}

bool KeyboardLayout::is_practiceable(char c)
{
    init_maps();
    if (c == ' ') return true;
    return char_map_.find(c) != char_map_.end();
}

bool KeyboardLayout::is_space(char c)
{
    return c == ' ';
}
