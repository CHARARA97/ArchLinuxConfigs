eval "$(starship init zsh)"
#语法检查和高亮
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#开启tab上下左右选择补全
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

alias icat="kitty +kitten icat"
alias ls="ls --color=auto"
alias so="source ~/.zshrc"
alias grep="grep --color=auto"
alias f="fastfetch"
alias mpg97="python3 -u ~/scripts/MPG-97.py"
alias nv='NVIM_APPNAME="nvim-test" nvim'
alias cfsync="cd ~/ArchLinuxConfigs && ./sync.sh -a"
alias s="steam -shutdown"
# 设置历史记录文件的路径
HISTFILE=~/.zsh_history

# 设置在会话（内存）中和历史文件中保存的条数，建议设置得大一些
HISTSIZE=10000
SAVEHIST=10000

# 忽略重复的命令，连续输入多次的相同命令只记一次
setopt HIST_IGNORE_DUPS

# 忽略以空格开头的命令（用于临时执行一些你不想保存的敏感命令）
setopt HIST_IGNORE_SPACE

# 在多个终端之间实时共享历史记录 
# 这是实现多终端同步最关键的选项
setopt SHARE_HISTORY

# 让新的历史记录追加到文件，而不是覆盖
setopt APPEND_HISTORY
# 在历史记录中记录命令的执行开始时间和持续时间
setopt EXTENDED_HISTORY
eval "$(zoxide init zsh --cmd cd)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

#确保配置只在交互式Shell中生效
[[ -o interactive ]] || return

#环境变量
export XMODIFIERS=@im=fcitx
export GIT_TERMINAL_PROMPT=0
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
activate-conda() {
    # 请将下面的路径替换为你的实际 Anaconda 安装路径
    local CONDA_BASE_PATH="/home/CHARARA97/anaconda3"
    
    # 加载 Conda 的 Shell 函数
    if [ -f "$CONDA_BASE_PATH/etc/profile.d/conda.sh" ]; then
        source "$CONDA_BASE_PATH/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_BASE_PATH/bin:$PATH"
    fi
    
    echo "Conda 已加载，现在可以使用 conda activate"
}

alias cl='activate-conda'

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)" > /dev/null
fi



