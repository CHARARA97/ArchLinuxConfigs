#include "ui_menu.h"
#include "keyboard.h"
#include "wordlist.h"
#include <ncurses.h>
#include <algorithm>
#include <cctype>
#include <wchar.h>
#include <locale.h>

// ──────────────────────────────────────────────
// 颜色对常量
// ──────────────────────────────────────────────
enum ColorPairs {
    CP_DEFAULT  = 1,
    CP_HIGHLIGHT = 2,   // 选中项
    CP_TITLE    = 3,    // 标题
    CP_DIM      = 4,    // 灰暗
    CP_GREEN    = 5,    // 绿色（高亮）
};

static void init_colors()
{
    if (has_colors()) {
        start_color();
        init_pair(CP_DEFAULT,  COLOR_WHITE,   COLOR_BLACK);
        init_pair(CP_HIGHLIGHT, COLOR_BLACK,   COLOR_CYAN);
        init_pair(CP_TITLE,    COLOR_CYAN,    COLOR_BLACK);
        init_pair(CP_DIM,      COLOR_GREEN,   COLOR_BLACK);
    }
}

// ──────────────────────────────────────────────
// 工具：UTF-8 字符串的显示宽度（用 wcwidth 正确处理 CJK 双宽字符）
// ──────────────────────────────────────────────
static int display_width(const std::string& s)
{
    int w = 0;
    mbstate_t state{};
    for (size_t i = 0; i < s.size(); ) {
        wchar_t wc;
        size_t len = mbrtowc(&wc, &s[i], s.size() - i, &state);
        if (len == (size_t)-1 || len == (size_t)-2) {
            i++; w++;  // 无效字节，算1列
        } else if (len == 0) {
            break;
        } else {
            i += len;
            w += std::max(1, wcwidth(wc));  // wcwidth 返回 -1 的按 1 算
        }
    }
    return w;
}

// ──────────────────────────────────────────────
// 工具：居中打印（按显示宽度）
// ──────────────────────────────────────────────
static void mvprintw_center(int y, const std::string& text, int color = CP_DEFAULT)
{
    int cols = getmaxx(stdscr);
    int x = std::max(0, (cols - display_width(text)) / 2);
    if (color != CP_DEFAULT) wattron(stdscr, COLOR_PAIR(color));
    mvprintw(y, x, "%s", text.c_str());
    if (color != CP_DEFAULT) wattroff(stdscr, COLOR_PAIR(color));
}

// ──────────────────────────────────────────────
// 主菜单
// ──────────────────────────────────────────────
MainMenuChoice render_main_menu()
{
    init_colors();
    const std::vector<std::string> items = {
        "  开始练习  ",
        "  配置设置  ",
        "  退出      "
    };
    int selected = 0;
    int rows, cols;
    getmaxyx(stdscr, rows, cols);

    int ch;
    while (true) {
        erase();
        int y = rows / 3;

        // 标题
        // 三行等宽 24 显示列（全 ASCII 避免 CJK 双宽问题）
        mvprintw_center(y,   "╔══════════════════════╗", CP_TITLE);
        mvprintw_center(y+1, "║  DVP Practicer v1.0  ║", CP_TITLE);
        mvprintw_center(y+2, "╚══════════════════════╝", CP_TITLE);

        y += 4;

        // 选项
        for (size_t i = 0; i < items.size(); ++i) {
            int line_y = y + static_cast<int>(i) * 2;
            if (static_cast<int>(i) == selected) {
                attron(A_REVERSE | COLOR_PAIR(CP_HIGHLIGHT));
            }
            mvprintw_center(line_y, items[i]);
            if (static_cast<int>(i) == selected) {
                attroff(A_REVERSE | COLOR_PAIR(CP_HIGHLIGHT));
            }
        }

        // 底部提示
        mvprintw(rows - 2, 2, "↑↓ 选择    Enter 确认");
        refresh();

        ch = getch();
        if (ch == KEY_UP && selected > 0) selected--;
        else if (ch == KEY_DOWN && selected < static_cast<int>(items.size()) - 1) selected++;
        else if (ch == '\n') break;
        else if (ch == 27) selected = 2;  // Esc → 退出
    }

    switch (selected) {
        case 0: return MainMenuChoice::START;
        case 1: return MainMenuChoice::CONFIG;
        default: return MainMenuChoice::EXIT;
    }
}

// ──────────────────────────────────────────────
// 配置界面
// ──────────────────────────────────────────────
bool render_config_menu(Config& config)
{
    // ── 内部状态 ──
    enum FocusArea {
        FOCUS_MODE,       // 练习模式
        FOCUS_KEYSET,     // 键集选择
        FOCUS_GROUP_SIZE, // 词长
        FOCUS_TOTAL,      // 总量
        FOCUS_BACKSPACE,  // 允许退格
        FOCUS_WORDLIST,   // 词库选择（仅词库模式可见）
        FOCUS_SAVE,       // 保存按钮
        FOCUS_DISCARD,    // 放弃按钮
    };

    FocusArea focus = FOCUS_MODE;

    // 工作副本
    PracticeMode cfg_mode = config.mode;
    std::vector<std::string> presets = config.selected_preset_names;
    std::string custom = config.custom_chars;
    int group_size = config.group_size;
    int total_chars = config.total_chars;
    bool allow_bs = config.allow_backspace;
    std::string wordlist_path = config.wordlist_path;

    // 获取所有预设键集
    const auto& all_presets = KeyboardLayout::preset_key_sets();

    // 获取可用词库
    auto wordlists = WordListManager::list_available();
    int selected_wordlist = 0;
    // 找到当前词库在列表中的位置
    for (size_t i = 0; i < wordlists.size(); ++i) {
        if (wordlists[i].filename == wordlist_path ||
            wordlists[i].full_path == wordlist_path) {
            selected_wordlist = static_cast<int>(i);
            break;
        }
    }

    // 在键集列表中，哪些是被选中的
    std::vector<bool> preset_checked(all_presets.size(), false);
    for (size_t i = 0; i < all_presets.size(); ++i) {
        for (const auto& sel : presets) {
            if (all_presets[i].name == sel) {
                preset_checked[i] = true;
                break;
            }
        }
    }
    bool custom_checked = !custom.empty();

    // 键集列表滚动偏移
    int keyset_scroll = 0;

    // ── 循环 ──
    int ch;
    bool saved = false;
    bool running = true;

    while (running) {
        erase();
        int rows, cols;
        getmaxyx(stdscr, rows, cols);
        int y = 1;

        // ── 标题 ──
        attron(COLOR_PAIR(CP_TITLE) | A_BOLD);
        mvprintw_center(y, "=== 配置设置 ===");
        attroff(COLOR_PAIR(CP_TITLE) | A_BOLD);
        y += 2;

        // ── 练习模式 ──
        {
            bool is_focused = (focus == FOCUS_MODE);
            if (is_focused) attron(A_REVERSE);
            mvprintw(y, 4, "练习模式: ");
            if (cfg_mode == PracticeMode::RANDOM) {
                printw("[● 随机字符]  [○ 词库模式]");
            } else {
                printw("[○ 随机字符]  [● 词库模式]");
            }
            if (is_focused) attroff(A_REVERSE);
            y += 2;
        }

        // ── 键集选择 ──
        {
            mvprintw(y, 4, "键集选择 (↑↓移动 空格切换 Tab到下一项):");
            y++;
            int max_visible = rows - y - 10; // 预留空间
            if (max_visible < 3) max_visible = 3;

            int total_items = static_cast<int>(all_presets.size()) + 1; // +1 for custom

            // 可见范围
            for (int i = keyset_scroll; i < total_items && i < keyset_scroll + max_visible; ++i) {
                bool is_focused = (focus == FOCUS_KEYSET && i == keyset_scroll);
                // 计算真正在列表中的索引
                int preset_idx = i;
                if (preset_idx < static_cast<int>(all_presets.size())) {
                    bool checked = preset_checked[preset_idx];
                    const auto& ps = all_presets[preset_idx];
                    if (is_focused) attron(A_REVERSE);
                    mvprintw(y, 6, "[%c] %s", checked ? 'x' : ' ', ps.name.c_str());
                    if (is_focused) attroff(A_REVERSE);
                    y++;
                } else {
                    // 自定义
                    bool checked = custom_checked;
                    if (is_focused) attron(A_REVERSE);
                    mvprintw(y, 6, "[%c] 自定义: %s",
                        checked ? 'x' : ' ',
                        custom.empty() ? "(未设置)" : custom.c_str());
                    if (is_focused) attroff(A_REVERSE);
                    y++;
                }
            }

            // 如果列表可以滚动，显示提示
            if (total_items > max_visible) {
                mvprintw(y, 6, "(还有 %d 项, 继续移动以滚动)", total_items - max_visible);
                y++;
            }
            y++;
        }

        // ── 词长(组大小) ──
        {
            bool is_focused = (focus == FOCUS_GROUP_SIZE);
            if (is_focused) attron(A_REVERSE);
            mvprintw(y, 4, "词长(组大小): %d   (+/- 调整, Enter 输入)", group_size);
            if (is_focused) attroff(A_REVERSE);
            y += 2;
        }

        // ── 练习总量 ──
        {
            bool is_focused = (focus == FOCUS_TOTAL);
            if (is_focused) attron(A_REVERSE);
            mvprintw(y, 4, "练习总量: %d   (+/- 调整)", total_chars);
            if (is_focused) attroff(A_REVERSE);
            y += 2;
        }

        // ── 允许退格 ──
        {
            bool is_focused = (focus == FOCUS_BACKSPACE);
            if (is_focused) attron(A_REVERSE);
            mvprintw(y, 4, "允许退格: [%c]", allow_bs ? 'x' : ' ');
            if (is_focused) attroff(A_REVERSE);
            y += 2;
        }

        // ── 词库选择（仅词库模式） ──
        if (cfg_mode == PracticeMode::WORDLIST) {
            mvprintw(y, 4, "词库文件:");
            y++;
            int start_y = y;
            int max_visible = rows - y - 4;
            if (wordlists.empty()) {
                mvprintw(y, 6, "(暂无词库文件, 请放入 %s 目录)",
                    ConfigManager::get_wordlist_dir().c_str());
                y += 2;
            } else {
                // 显示词库列表
                int wordlist_scroll = std::max(0, selected_wordlist - max_visible / 2);
                for (int i = wordlist_scroll;
                     i < static_cast<int>(wordlists.size()) && i < wordlist_scroll + max_visible;
                     ++i) {
                    bool is_focused = (focus == FOCUS_WORDLIST && i == selected_wordlist);
                    const char* marker = (i == selected_wordlist) ? ">" : " ";
                    if (is_focused) attron(A_REVERSE);
                    mvprintw(start_y + (i - wordlist_scroll), 6, "%s %s (%d词)",
                        marker, wordlists[i].filename.c_str(), wordlists[i].word_count);
                    if (is_focused) attroff(A_REVERSE);
                }
                y = start_y + std::min(max_visible, static_cast<int>(wordlists.size())) + 1;
            }
        }

        // ── 按钮 ──
        {
            y = rows - 3;
            bool save_focused = (focus == FOCUS_SAVE);
            bool discard_focused = (focus == FOCUS_DISCARD);

            int btn_x = cols / 2 - 15;
            if (save_focused) attron(A_REVERSE);
            mvprintw(y, btn_x, "[ 保存 ]");
            if (save_focused) attroff(A_REVERSE);

            if (discard_focused) attron(A_REVERSE);
            mvprintw(y, btn_x + 12, "[ 放弃 ]");
            if (discard_focused) attroff(A_REVERSE);
        }

        // ── 底部提示 ──
        mvprintw(rows - 1, 2, "Tab: 切换焦点  Enter: 确认  方向键/+/-/空格: 调整  Esc: 放弃返回");
        refresh();

        // ── 输入处理 ──
        ch = getch();

        if (ch == 27) { // Esc → 放弃
            running = false;
            saved = false;
            break;
        }

        if (ch == '\t' || ch == KEY_BTAB) {
            // Tab 切换焦点
            int dir = (ch == '\t') ? 1 : -1;
            int max_focus = (cfg_mode == PracticeMode::WORDLIST) ? FOCUS_DISCARD : FOCUS_DISCARD;
            int f = static_cast<int>(focus);
            do {
                f = (f + dir + max_focus + 1) % (max_focus + 1);
            } while (f == FOCUS_WORDLIST && cfg_mode != PracticeMode::WORDLIST);
            focus = static_cast<FocusArea>(f);
            continue;
        }

        switch (focus) {
            case FOCUS_MODE: {
                // 左右切换模式
                if (ch == KEY_LEFT || ch == KEY_RIGHT) {
                    cfg_mode = (cfg_mode == PracticeMode::RANDOM)
                        ? PracticeMode::WORDLIST : PracticeMode::RANDOM;
                }
                break;
            }

            case FOCUS_KEYSET: {
                int total_items = static_cast<int>(all_presets.size()) + 1;
                int current = keyset_scroll;
                if (ch == KEY_UP && keyset_scroll > 0) {
                    keyset_scroll--;
                } else if (ch == KEY_DOWN && keyset_scroll < total_items - 1) {
                    keyset_scroll++;
                } else if (ch == ' ') {
                    // 切换选中
                    if (keyset_scroll < static_cast<int>(all_presets.size())) {
                        preset_checked[keyset_scroll] = !preset_checked[keyset_scroll];
                    } else {
                        // 自定义：暂不支持在菜单中编辑，仅在选中时标记
                        custom_checked = !custom_checked;
                        if (custom_checked && custom.empty()) {
                            // 提示用户输入
                            mvprintw(rows - 2, 2, "请输入自定义字符 (不含空格): ");
                            echo();
                            char buf[256] = {0};
                            getnstr(buf, 255);
                            noecho();
                            // 去除首尾空白（防止空格混入字符集）
                            std::string raw(buf);
                            auto s = raw.find_first_not_of(" \t");
                            auto e = raw.find_last_not_of(" \t");
                            custom = (s != std::string::npos)
                                ? raw.substr(s, e - s + 1) : "";
                        } else if (!custom_checked) {
                            custom.clear();
                        }
                    }
                }
                break;
            }

            case FOCUS_GROUP_SIZE: {
                if (ch == '+' || ch == KEY_RIGHT) {
                    group_size = std::min(100, group_size + 1);
                } else if (ch == '-' || ch == KEY_LEFT) {
                    group_size = std::max(1, group_size - 1);
                } else if (ch == '\n') {
                    // 手动输入
                    mvprintw(rows - 2, 2, "输入词长 (1-100): ");
                    echo();
                    char buf[16] = {0};
                    getnstr(buf, 15);
                    noecho();
                    int val = atoi(buf);
                    if (val >= 1 && val <= 100) group_size = val;
                }
                break;
            }

            case FOCUS_TOTAL: {
                if (ch == '+' || ch == KEY_RIGHT) {
                    total_chars = std::min(100000, total_chars + 10);
                } else if (ch == '-' || ch == KEY_LEFT) {
                    total_chars = std::max(10, total_chars - 10);
                } else if (ch == '\n') {
                    mvprintw(rows - 2, 2, "输入练习总量 (10-100000): ");
                    echo();
                    char buf[16] = {0};
                    getnstr(buf, 15);
                    noecho();
                    int val = atoi(buf);
                    if (val >= 10 && val <= 100000) total_chars = val;
                }
                break;
            }

            case FOCUS_BACKSPACE: {
                if (ch == ' ') {
                    allow_bs = !allow_bs;
                }
                break;
            }

            case FOCUS_WORDLIST: {
                if (ch == KEY_UP && selected_wordlist > 0) {
                    selected_wordlist--;
                } else if (ch == KEY_DOWN &&
                           selected_wordlist < static_cast<int>(wordlists.size()) - 1) {
                    selected_wordlist++;
                } else if (ch == '\n' && !wordlists.empty()) {
                    wordlist_path = wordlists[selected_wordlist].full_path;
                }
                break;
            }

            case FOCUS_SAVE: {
                if (ch == '\n' || ch == ' ') {
                    // 保存并返回
                    saved = true;
                    running = false;
                }
                break;
            }

            case FOCUS_DISCARD: {
                if (ch == '\n' || ch == ' ') {
                    saved = false;
                    running = false;
                }
                break;
            }
        }

        // 在保存前更新配置
        if (!running && saved) {
            // 收集选中的预设名称
            std::vector<std::string> selected_presets;
            for (size_t i = 0; i < all_presets.size(); ++i) {
                if (preset_checked[i]) {
                    selected_presets.push_back(all_presets[i].name);
                }
            }

            config.mode = cfg_mode;
            config.selected_preset_names = selected_presets;
            config.custom_chars = custom_checked ? custom : "";
            config.group_size = group_size;
            config.total_chars = total_chars;
            config.allow_backspace = allow_bs;
            config.wordlist_path = wordlist_path;
            config.selected_chars = ConfigManager::merge_key_sets(
                selected_presets, config.custom_chars);

            ConfigManager::save(config);
        }
    }

    return saved;
}
