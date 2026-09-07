#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias icat="kitty +kitten icat"
alias ls="ls --color=auto"
alias so="source ~/.zshrc"
alias grep="grep --color=auto"
alias f="fastfetch"
alias mpg97="python3 -u ~/scripts/MPG-97.py"
alias nv="neovide"
alias cfsync="cd ~/ArchLinuxConfigs && ./sync.sh -a"
alias s="steam -shutdown"
alias how="tldr"
PS1='[\u@\h \W]\$ '

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)" > /dev/null
fi
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
