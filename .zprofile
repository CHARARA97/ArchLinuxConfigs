# ~/.zprofile — 登录 shell 配置
# 职责：会话范围的环境变量 + 图形会话启动（Arch Wiki: Zsh#Startup/Shutdown files）

# ---------- 语言和区域 ----------
export LANG="zh_CN.UTF-8"
export LANGUAGE="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"
export LC_MESSAGES="zh_CN.UTF-8"

# ---------- 输入法 (Fcitx) ----------
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
export SDL_IM_MODULE="fcitx"
export GLFW_IM_MODULE="ibus"

# ---------- Qt / Gtk 图形界面 ----------
export QT_QPA_PLATFORMTHEME="qt6ct"
export GSK_RENDERER="ql"
export GDK_DPI_SCALE="1.25"
export GTK_CSD="0"

# ---------- 其他 ----------
export EDITOR="nvim"

# Created by `pipx` on 2026-05-16 03:40:23
export PATH="$PATH:/home/CHARARA97/.local/bin"

# tty1 直接登录时自动进入 niri 桌面（图形登录管理器启动则跳过）
if [[ -z "${WAYLAND_DISPLAY}" && "${XDG_VTNR}" == "1" ]]; then
    exec niri-session -l
fi
