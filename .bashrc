# ~/.bashrc — 备用 shell 配置（主力是 zsh，本文件保持精简）

[[ $- != *i* ]] && return

# 与 ~/.zshrc 中的别名保持一致（双份维护，修改时记得同步）
alias f="fastfetch"
alias s="steam -shutdown"
alias ls="ls --color=auto"
alias so="source ~/.bashrc"
alias nv="neovide"
alias how="tldr"
alias icat="kitty +kitten icat"
alias grep="grep --color=auto"
alias mpg97="python3 -u ~/scripts/MPG-97.py"
alias cfsync="cd ~/ArchLinuxConfigs && ./sync.sh -a"

PS1='[\u@\h \W]\$ '

# SSH agent 由 systemd 用户服务 ssh-agent.service 常驻（同 zshrc）
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# 语言和区域
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
