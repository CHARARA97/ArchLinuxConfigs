#include "ui_stats.h"
#include <ncurses.h>
#include <string>
#include <algorithm>

// ──────────────────────────────────────────────
// 统计结束界面
// ──────────────────────────────────────────────
void render_stats_screen(const SessionStats& stats, const Config& config)
{
    int rows, cols;
    getmaxyx(stdscr, rows, cols);

    erase();

    int y = 1;

    // ── 标题 ──
    attron(A_BOLD | COLOR_PAIR(3)); // CP_TITLE
    int title_x = std::max(0, (cols - 18) / 2);
    mvprintw(y, title_x, "=== 练习统计 ===");
    attroff(A_BOLD | COLOR_PAIR(3));
    y += 2;

    // ── 总体统计 ──
    mvprintw(y, 4, "总字符: %d    正确: %d    错误: %d",
        stats.total_chars, stats.correct_count, stats.error_count);
    y++;

    mvprintw(y, 4, "正确率: %.1f%%", stats.accuracy * 100.0);
    y++;

    mvprintw(y, 4, "速度: %.0f CPM", stats.cpm);
    y++;

    // 格式化时间
    int total_secs = static_cast<int>(stats.duration_secs);
    int mins = total_secs / 60;
    int secs = total_secs % 60;
    mvprintw(y, 4, "用时: %d分%d秒", mins, secs);
    y++;

    mvprintw(y, 4, "超5s丢弃样本: %d", stats.dropped_samples);
    y += 2;

    // ── 各键错误排行榜 ──
    mvprintw(y, 4, "── 各键错误排行 ──");
    y++;

    if (stats.sorted_by_error.empty()) {
        mvprintw(y, 6, "无错误！");
        y++;
    } else {
        int max_show = std::min(8, static_cast<int>(stats.sorted_by_error.size()));
        for (int i = 0; i < max_show; ++i) {
            const auto& ks = stats.sorted_by_error[i];

            // 显示: 1. e → d(3)  r(2)  错误5次
            std::string line = "  ";
            line += std::to_string(i + 1) + ". '";
            line += ks.key;
            line += "'  错误" + std::to_string(ks.error_count) + "次";
            line += "  正确率" + std::to_string(static_cast<int>(ks.accuracy * 100)) + "%";

            // 常错成什么
            if (!ks.misstrokes.empty()) {
                line += "  常错成: ";
                int max_show_mis = std::min(3, static_cast<int>(ks.misstrokes.size()));
                for (int m = 0; m < max_show_mis; ++m) {
                    if (m > 0) line += " ";
                    line += "'";
                    line += ks.misstrokes[m].first;
                    line += "'(" + std::to_string(ks.misstrokes[m].second) + ")";
                }
            }

            if (static_cast<int>(line.size()) > cols - 4) {
                line = line.substr(0, cols - 7) + "...";
            }
            mvprintw(y, 6, "%s", line.c_str());
            y++;
        }
    }

    y++;

    // ── 各键耗时排行榜 ──
    mvprintw(y, 4, "── 各键耗时排行 (已丢弃超5s样本) ──");
    y++;

    if (stats.sorted_by_time.empty()) {
        mvprintw(y, 6, "（暂无有效耗时数据）");
        y++;
    } else {
        int max_show = std::min(8, static_cast<int>(stats.sorted_by_time.size()));
        for (int i = 0; i < max_show; ++i) {
            const auto& ks = stats.sorted_by_time[i];

            std::string line = "  ";
            line += std::to_string(i + 1) + ". '";
            line += ks.key;
            line += "'  " + std::to_string(static_cast<int>(ks.avg_reaction_time * 1000)) + "ms";
            line += "  (样本: " + std::to_string(ks.valid_time_samples) + "次)";

            if (static_cast<int>(line.size()) > cols - 4) {
                line = line.substr(0, cols - 7) + "...";
            }
            mvprintw(y, 6, "%s", line.c_str());
            y++;
        }
    }

    // ── 底部提示 ──
    mvprintw(rows - 2, 2, "按 Enter 返回主菜单...");
    refresh();

    // 等待用户按键
    int ch;
    do {
        ch = getch();
    } while (ch != '\n' && ch != 27 && ch != ' ');
}
