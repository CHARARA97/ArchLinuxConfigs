#include "ui_menu.h"
#include "ui_practice.h"
#include "config.h"
#include <ncurses.h>
#include <cstdlib>
#include <locale>

int main()
{
    // ── 启用 locale (UTF-8 支持) ──
    setlocale(LC_ALL, "");

    // ── 消除 Esc 键的 1 秒延迟 ──
    ESCDELAY = 0;

    // ── 初始化 ncurses ──
    initscr();
    raw();
    noecho();
    keypad(stdscr, TRUE);
    curs_set(0);          // 隐藏光标

    // ── 初始化颜色 ──
    if (has_colors()) {
        start_color();
        // 基础颜色对（与 ui_menu 和 ui_practice 一致）
        init_pair(1, COLOR_WHITE, COLOR_BLACK);  // CP_DEFAULT
        init_pair(2, COLOR_BLACK, COLOR_CYAN);   // CP_HIGHLIGHT
        init_pair(3, COLOR_CYAN,  COLOR_BLACK);  // CP_TITLE
        init_pair(4, COLOR_WHITE, COLOR_BLACK);  // CP_GRAY (A_DIM)
        init_pair(5, COLOR_GREEN, COLOR_BLACK);  // CP_GREEN
        init_pair(6, COLOR_RED,   COLOR_BLACK);  // CP_RED
        init_pair(7, COLOR_WHITE, COLOR_BLACK);  // CP_WHITE
        init_pair(8, COLOR_WHITE, COLOR_BLACK);  // CP_BRIGHT (A_BOLD)
        init_pair(9, COLOR_GREEN, COLOR_BLACK);  // CP_KB_GREEN 绿字黑底
    }

    // ── 确保配置目录存在 ──
    ConfigManager::ensure_dirs();

    // ── 加载配置 ──
    Config config = ConfigManager::load();

    // ── 主循环 ──
    bool running = true;
    while (running) {
        MainMenuChoice choice = render_main_menu();

        switch (choice) {
            case MainMenuChoice::START:
                if (!config.is_valid()) {
                    // 显示错误，自动进入配置界面
                    erase();
                    mvprintw(2, 2, "%s", config.validation_error().c_str());
                    mvprintw(4, 2, "按任意键进入配置...");
                    refresh();
                    getch();
                    render_config_menu(config);
                } else {
                    run_practice_session(config);
                }
                break;

            case MainMenuChoice::CONFIG:
                render_config_menu(config);
                break;

            case MainMenuChoice::EXIT:
                running = false;
                break;
        }
    }

    // ── 清理 ──
    endwin();
    return 0;
}
