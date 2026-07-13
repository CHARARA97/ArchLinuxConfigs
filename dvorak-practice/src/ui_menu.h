#ifndef DVORAK_PRACTICE_UI_MENU_H
#define DVORAK_PRACTICE_UI_MENU_H

#include "config.h"

enum class MainMenuChoice { START, CONFIG, EXIT };

// 渲染主菜单，返回用户选择
MainMenuChoice render_main_menu();

// 渲染配置界面，返回 true=已保存，false=放弃
// 传入/传出 Config 引用
bool render_config_menu(Config& config);

#endif
