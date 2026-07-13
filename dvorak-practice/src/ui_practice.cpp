#include "ui_practice.h"
#include "ui_stats.h"
#include "practice.h"
#include "statistics.h"
#include "history.h"
#include "keyboard.h"
#include "wordlist.h"
#include <ncurses.h>
#include <algorithm>
#include <string>
#include <sstream>
#include <wchar.h>
#include <locale.h>

// ──────────────────────────────────────────────
// 颜色对（额外定义, 与 ui_menu 中的合并）
// ──────────────────────────────────────────────
namespace {
    const int CP_DEFAULT    = 1;
    const int CP_HIGHLIGHT  = 2;
    const int CP_TITLE      = 3;
    const int CP_GRAY       = 4;    // 灰色（未打字）
    const int CP_GREEN      = 5;    // 绿色（刚打对）
    const int CP_RED        = 6;    // 红色（错误）
    const int CP_WHITE      = 7;    // 白色（已打对）
    const int CP_BRIGHT     = 8;    // 亮白（当前候打）
    const int CP_KB_GREEN   = 9;    // 键盘高亮绿色
    const int CP_KB_NORMAL  = 10;   // 键盘普通
}

static void init_practice_colors()
{
    if (has_colors()) {
        init_pair(CP_DEFAULT,   COLOR_WHITE,   COLOR_BLACK);
        init_pair(CP_HIGHLIGHT, COLOR_BLACK,   COLOR_CYAN);
        init_pair(CP_TITLE,     COLOR_CYAN,    COLOR_BLACK);
        init_pair(CP_GRAY,      COLOR_WHITE,   COLOR_BLACK);  // 普通白色，但用 A_DIM 实现灰色
        init_pair(CP_GREEN,     COLOR_GREEN,   COLOR_BLACK);
        init_pair(CP_RED,       COLOR_RED,     COLOR_BLACK);
        init_pair(CP_WHITE,     COLOR_WHITE,   COLOR_BLACK);
        init_pair(CP_BRIGHT,    COLOR_WHITE,   COLOR_BLACK);  // 亮白用 A_BOLD
        init_pair(CP_KB_GREEN,  COLOR_GREEN,   COLOR_BLACK);  // 绿字黑底
        init_pair(CP_KB_NORMAL, COLOR_WHITE,   COLOR_BLACK);
    }
}

// ──────────────────────────────────────────────
// 渲染练习文本（按词换行，不截断词）
// ──────────────────────────────────────────────
// 预计算每行的起止字符索引（按词边界分行）
static std::vector<std::pair<int,int>> compute_line_breaks(
    const std::vector<char>& targets, int cols)
{
    std::vector<std::pair<int,int>> breaks;
    if (targets.empty() || cols < 1) return breaks;

    int i = 0;
    int total = static_cast<int>(targets.size());
    while (i < total) {
        int line_start = i;
        int line_end = i + cols;
        if (line_end >= total) {
            // 最后一行：直接到末尾
            breaks.push_back({line_start, total});
            break;
        }
        // 从 line_end 往前找空格（词边界），不超过 line_start
        int break_at = line_end;
        while (break_at > line_start && targets[break_at] != ' '
               && targets[break_at - 1] != ' ') {
            break_at--;
        }
        // 如果没找到空格，强行在 cols 处截断
        if (break_at == line_start) {
            break_at = line_end;
        }
        breaks.push_back({line_start, break_at});
        // 跳过词间的空格
        i = break_at;
        while (i < total && targets[i] == ' ') i++;
    }
    return breaks;
}

static void render_text(WINDOW* win, const PracticeEngine& engine)
{
    const auto& targets = engine.get_targets();
    const auto& slots = engine.get_slots();
    int pos = engine.get_pos();

    int rows = getmaxy(win);
    int cols = getmaxx(win);
    if (cols < 1) cols = 1;
    if (rows < 1) rows = 1;

    int total = static_cast<int>(targets.size());
    if (total == 0) return;

    // 预计算分行
    auto line_breaks = compute_line_breaks(targets, cols);
    int num_lines = static_cast<int>(line_breaks.size());
    if (num_lines == 0) return;

    // 找到光标所在行
    int cursor_line = 0;
    for (int L = 0; L < num_lines; ++L) {
        if (pos < line_breaks[L].second || (L == num_lines - 1 && pos <= line_breaks[L].second)) {
            cursor_line = L;
            break;
        }
    }

    // 滚动使光标行在可视区靠下位置
    int start_line = cursor_line - rows + 2;
    if (start_line < 0) start_line = 0;

    werase(win);

    // 逐行渲染
    for (int r = 0; r < rows; ++r) {
        int idx = start_line + r;
        if (idx >= num_lines) break;

        auto [line_start, line_end] = line_breaks[idx];
        int col = 0;

        for (int i = line_start; i < line_end && col < cols; ++i, ++col) {
            char ch = targets[i];

            if (i < pos) {
                if (slots[i].is_correct) {
                    if (i == pos - 1)
                        wattron(win, COLOR_PAIR(CP_GREEN));
                    else
                        wattron(win, COLOR_PAIR(CP_WHITE));
                } else {
                    wattron(win, COLOR_PAIR(CP_RED));
                }
            } else if (i == pos) {
                if (slots[i].has_wrong_attempt)
                    wattron(win, A_BOLD | COLOR_PAIR(CP_RED));
                else
                    wattron(win, COLOR_PAIR(CP_WHITE));
            } else {
                wattron(win, A_DIM | COLOR_PAIR(CP_GRAY));
            }

            mvwaddch(win, r, col, ch);
            wattroff(win, A_BOLD | A_DIM | COLOR_PAIR(CP_GREEN) | COLOR_PAIR(CP_RED)
                         | COLOR_PAIR(CP_WHITE) | COLOR_PAIR(CP_BRIGHT) | COLOR_PAIR(CP_GRAY));
        }

        // 清空行尾
        if (col < cols) {
            wmove(win, r, col);
            wclrtoeol(win);
        }
    }
}

// ──────────────────────────────────────────────
// 渲染统计栏
// ──────────────────────────────────────────────
static void render_stats(WINDOW* win, const PracticeEngine& engine)
{
    int max_x = getmaxx(win);
    int pos = engine.get_pos();
    int total = engine.get_total();
    double acc = engine.get_accuracy() * 100.0;
    double cpm = engine.get_cpm();
    int word = engine.get_current_word();
    int total_words = engine.get_total_words();
    int dropped = engine.get_dropped_samples();
    double target_time = engine.get_current_target_time();

    // 上排: 主要统计
    std::string line1;
    line1 += "进度: " + std::to_string(pos) + "/" + std::to_string(total);
    line1 += "  正确率: " + std::to_string(static_cast<int>(acc)) + "%";
    line1 += "  速度: " + std::to_string(static_cast<int>(cpm)) + " CPM";
    line1 += "  词: " + std::to_string(word) + "/" + std::to_string(total_words);
    line1 += "  丢弃: " + std::to_string(dropped);

    // 如果有当前候打的计时，显示
    if (target_time > 0) {
        line1 += "  当前: " + std::to_string(static_cast<int>(target_time * 10) / 10.0) + "s";
    }

    // 确保不超宽
    if (static_cast<int>(line1.size()) > max_x) {
        line1 = line1.substr(0, max_x);
    }

    wmove(win, 0, 0);
    wclrtoeol(win);
    mvwprintw(win, 0, 0, "%s", line1.c_str());

    // 下排: 进度条
    if (total > 0) {
        int bar_width = std::min(max_x - 2, 50);
        int filled = (pos * bar_width) / total;
        std::string bar = "[" + std::string(filled, '#') + std::string(bar_width - filled, '.') + "]";
        mvwprintw(win, 1, 0, "%s", bar.c_str());
    }

    wclrtoeol(win);
}

// ──────────────────────────────────────────────
// 渲染键盘指示器
// ──────────────────────────────────────────────
static void render_keyboard(WINDOW* win, const PracticeEngine& engine)
{
    const auto& full_lines = KeyboardLayout::full_display_lines();
    // 内容行在 full_lines 中的索引: R1=line1, R2=line3, R3=line5, R4=line7
    static const int content_row_map[] = {1, 3, 5, 7};

    char current = engine.get_current_target();
    const KeyPos* highlight = nullptr;
    if (current != '\0' && !KeyboardLayout::is_space(current)) {
        highlight = KeyboardLayout::find_char_pos(current);
    }

    int max_y = getmaxy(win);
    int lines = std::min(static_cast<int>(full_lines.size()), max_y);

    for (int row = 0; row < lines; ++row) {
        const std::string& line = full_lines[row];
        mvwprintw(win, row, 0, "%s", line.c_str());

        // 只对高亮字符所在的内容行做高亮
        if (highlight) {
            // 当前显示行对应哪个 parser row
            int parser_row = -1;
            for (int i = 0; i < 4; ++i) {
                if (content_row_map[i] == row) {
                    parser_row = i;
                    break;
                }
            }
            if (parser_row == highlight->row) {
                // 只高亮单个字符（绿色背景）
                mvwchgat(win, row, highlight->str_index, 1,
                         A_NORMAL, CP_KB_GREEN, nullptr);
            }
        }
    }

    // 清空底部剩余行
    for (int row = lines; row < max_y; ++row) {
        wmove(win, row, 0);
        wclrtoeol(win);
    }
}

// ──────────────────────────────────────────────
// 暂停菜单
// ──────────────────────────────────────────────
enum class PauseChoice { QUIT, RESTART, RESUME, NONE };

// UTF-8 字符串显示宽度 (局部版本, 不依赖 ui_menu.cpp)
static int str_display_w(const std::string& s)
{
    int w = 0;
    mbstate_t state{};
    for (size_t i = 0; i < s.size(); ) {
        wchar_t wc;
        size_t len = mbrtowc(&wc, &s[i], s.size() - i, &state);
        if (len == (size_t)-1 || len == (size_t)-2) { i++; w++; }
        else if (len == 0) break;
        else { i += len; w += std::max(1, wcwidth(wc)); }
    }
    return w;
}

// 居中打印到窗口
static void mvwprintw_center(WINDOW* win, int y, const std::string& text)
{
    int cols = getmaxx(win);
    int x = std::max(0, (cols - str_display_w(text)) / 2);
    mvwprintw(win, y, x, "%s", text.c_str());
}

static PauseChoice render_pause_menu(WINDOW* parent)
{
    // 全部用 ASCII 文本避免 CJK 宽度问题
    const std::vector<std::string> options = {
        "  1. Quit (to stats)  ",
        "  2. Restart          ",
        "  3. Resume           ",
    };

    // 计算菜单宽度: 最长选项 + 边距
    int max_w = 22; // 标题"== PAUSED =="的最小宽度
    for (const auto& opt : options) {
        int dw = str_display_w(opt);
        if (dw > max_w) max_w = dw;
    }
    int menu_w = max_w + 4;  // 2边各2 = 4
    int menu_h = static_cast<int>(options.size()) + 4; // 标题行+空行+选项+提示行+边距

    int max_x = getmaxx(parent);
    int max_y = getmaxy(parent);
    int menu_x = std::max(0, (max_x - menu_w) / 2);
    int menu_y = std::max(0, (max_y - menu_h) / 2);

    WINDOW* menu_win = newwin(menu_h, menu_w, menu_y, menu_x);
    keypad(menu_win, TRUE);

    int selected = 0;
    int ch;
    while (true) {
        werase(menu_win);
        box(menu_win, 0, 0);

        // 标题
        wattron(menu_win, A_BOLD | COLOR_PAIR(CP_TITLE));
        mvwprintw_center(menu_win, 1, "== PAUSED ==");
        wattroff(menu_win, A_BOLD | COLOR_PAIR(CP_TITLE));

        // 选项
        for (size_t i = 0; i < options.size(); ++i) {
            if (static_cast<int>(i) == selected)
                wattron(menu_win, A_REVERSE);
            mvwprintw_center(menu_win, 3 + static_cast<int>(i), options[i]);
            if (static_cast<int>(i) == selected)
                wattroff(menu_win, A_REVERSE);
        }

        // 底部提示
        mvwprintw(menu_win, menu_h - 1, 2, "UP/DOWN Enter");
        wrefresh(menu_win);

        ch = wgetch(menu_win);
        if (ch == KEY_UP && selected > 0) selected--;
        else if (ch == KEY_DOWN && selected < static_cast<int>(options.size()) - 1) selected++;
        else if (ch == '\n') break;
        else if (ch == 27) { selected = 2; break; }  // Esc → resume
    }

    delwin(menu_win);
    touchwin(parent);
    wrefresh(parent);

    switch (selected) {
        case 0: return PauseChoice::QUIT;
        case 1: return PauseChoice::RESTART;
        case 2: return PauseChoice::RESUME;
        default: return PauseChoice::RESUME;
    }
}

// ──────────────────────────────────────────────
// 练习会话主函数
// ──────────────────────────────────────────────
void run_practice_session(const Config& config)
{
    init_practice_colors();

    // 如果是词库模式，加载词库
    std::vector<std::string> wordlist_words;
    if (config.mode == PracticeMode::WORDLIST && !config.wordlist_path.empty()) {
        auto result = WordListManager::load(config.wordlist_path);
        if (result.success) {
            wordlist_words = WordListManager::filter_by_charset(
                result.words, config.selected_chars);
            if (wordlist_words.empty()) {
                // 显示错误并返回
                erase();
                mvprintw(2, 2, "错误: 词库中没有符合当前键集的单词。请更换词库或调整键集。");
                mvprintw(4, 2, "按任意键返回主菜单...");
                refresh();
                getch();
                return;
            }
        } else {
            erase();
            mvprintw(2, 2, "错误: %s", result.error_msg.c_str());
            mvprintw(4, 2, "按任意键返回主菜单...");
            refresh();
            getch();
            return;
        }
    }

    // 创建练习引擎
    PracticeEngine engine(config, wordlist_words);
    if (engine.get_total() == 0) {
        erase();
        mvprintw(2, 2, "错误: 无法生成练习序列。请检查配置。");
        mvprintw(4, 2, "按任意键返回主菜单...");
        refresh();
        getch();
        return;
    }

    // ── 创建 3 个子窗口 ──
    int rows, cols;
    getmaxyx(stdscr, rows, cols);

    // 键盘区域：9行键盘 + 1行间距 = 10行
    int kb_rows = 10;
    int stats_rows = 3;
    int text_rows = rows - kb_rows - stats_rows - 1;
    if (text_rows < 1) text_rows = 1;

    // 为了不破坏窗口边界，在每个窗口内保留一点内边距
    WINDOW* text_win = newwin(text_rows, cols - 2, 1, 1);
    WINDOW* stats_win = newwin(stats_rows, cols - 2, text_rows + 1, 1);
    WINDOW* kb_win = newwin(kb_rows, cols - 2, text_rows + stats_rows + 1, 1);

    // 开启键盘输入
    keypad(text_win, TRUE);
    nodelay(text_win, FALSE);
    raw();
    noecho();

    bool exit_to_stats = false;
    bool practice_finished = false;

    // lambda: 根据当前终端尺寸重建子窗口
    auto rebuild_wins = [&]() {
        int new_rows, new_cols;
        getmaxyx(stdscr, new_rows, new_cols);
        int new_kb = 10, new_stats = 3;
        int new_text = std::max(1, new_rows - new_kb - new_stats - 1);
        delwin(text_win); delwin(stats_win); delwin(kb_win);
        text_win  = newwin(new_text, new_cols - 2, 1, 1);
        stats_win = newwin(new_stats, new_cols - 2, new_text + 1, 1);
        kb_win    = newwin(new_kb, new_cols - 2, new_text + new_stats + 1, 1);
        keypad(text_win, TRUE);
    };

    // ── 主输入循环 ──
    while (!practice_finished && !exit_to_stats) {
        // 渲染
        werase(text_win);
        werase(stats_win);
        werase(kb_win);

        render_text(text_win, engine);
        render_stats(stats_win, engine);
        render_keyboard(kb_win, engine);

        wnoutrefresh(text_win);
        wnoutrefresh(stats_win);
        wnoutrefresh(kb_win);
        doupdate();

        // 读输入
        int ch = wgetch(text_win);

        // 终端尺寸变化
        if (ch == KEY_RESIZE) {
            rebuild_wins();
            continue;
        }

        // 只在非暂停时处理输入
        if (!engine.is_paused()) {
            if (ch == 27) { // Esc → 暂停
                engine.pause();

                // 渲染暂停菜单（覆盖在主窗口上）
                PauseChoice pchoice = render_pause_menu(stdscr);
                // 强制重绘所有子窗口（清除暂停菜单的残留）
                touchwin(text_win);
                touchwin(stats_win);
                touchwin(kb_win);
                switch (pchoice) {
                    case PauseChoice::QUIT:
                        exit_to_stats = true;
                        break;
                    case PauseChoice::RESTART:
                        engine.process_reset();
                        engine.resume();   // 重来后恢复
                        break;
                    case PauseChoice::RESUME:
                        engine.resume();
                        break;
                    default:
                        engine.resume();
                        break;
                }
                continue;
            } else if (ch == 3) { // Ctrl+C → 直接退出
                endwin();
                exit(0);
            } else if (ch == 127 || ch == 8 || ch == KEY_BACKSPACE) {
                // 退格
                engine.process_backspace();
            } else if (ch >= 32 && ch <= 126) {
                // 可打印字符 (包含空格 32 到 ~ 126)
                auto result = engine.process_input(static_cast<char>(ch));
                if (result.type == InputResult::Type::FINISHED) {
                    practice_finished = true;
                }
            }
        }
    }

    // ── 清理子窗口 ──
    delwin(text_win);
    delwin(stats_win);
    delwin(kb_win);

    // ── 计算统计 + 保存历史 ──
    SessionStats stats = StatisticsCalculator::calculate(
        engine.get_targets(),
        engine.get_slots(),
        engine.get_elapsed_seconds(),
        engine.get_attempts(),
        engine.get_dropped_samples()
    );

    HistoryManager::append(HistoryManager::from_stats(stats, config));

    // ── 显示统计界面 ──
    render_stats_screen(stats, config);
}
