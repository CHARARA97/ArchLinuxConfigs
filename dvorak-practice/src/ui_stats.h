#ifndef DVORAK_PRACTICE_UI_STATS_H
#define DVORAK_PRACTICE_UI_STATS_H

#include "statistics.h"
#include "config.h"

// 渲染结束统计界面
// 等待用户按 Enter 后返回
void render_stats_screen(const SessionStats& stats, const Config& config);

#endif
