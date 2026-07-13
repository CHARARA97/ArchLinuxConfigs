#ifndef DVORAK_PRACTICE_UI_PRACTICE_H
#define DVORAK_PRACTICE_UI_PRACTICE_H

#include "config.h"

// 进入练习会话（包含练习主循环 + 暂停菜单 + 统计结果）
// 在内部管理 PracticeEngine 和 ncurses 子窗口
// 当练习结束或用户退出时返回
void run_practice_session(const Config& config);

#endif
