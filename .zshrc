# ~/.zshrc — CHARARA97 的 zsh 配置

# ---------- 提示符与插件 ----------
eval "$(starship init zsh)"

# 语法高亮 / 自动建议（Arch 包提供；文件不存在则静默跳过，避免换环境报错）
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---------- 补全 ----------
# 开启 tab 上下左右选择补全
zstyle ':completion:*' menu select
autoload -Uz compinit && compinit

# zoxide 智能目录跳转（--cmd cd：用 z 替换 cd）
eval "$(zoxide init zsh --cmd cd)"

# ---------- 别名 ----------
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias f="fastfetch"
alias how="tldr"
alias icat="kitty +kitten icat"
alias nv="neovide"
alias mpg97="python3 -u ~/scripts/MPG-97.py"
alias cfsync="cd ~/ArchLinuxConfigs && ./sync.sh -a"
alias s="steam -shutdown"          # 关闭 Steam（单字母别名，小心误触）
alias cl='activate-conda'          # 手动激活 conda
alias so="source ~/.zshrc"

# ---------- 历史记录 ----------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS      # 连续重复命令只记一次
setopt HIST_IGNORE_SPACE     # 空格开头的命令不记录（敏感命令前加空格）
setopt SHARE_HISTORY         # 多终端实时共享历史
setopt APPEND_HISTORY        # 追加而非覆盖
setopt EXTENDED_HISTORY      # 记录时间戳与耗时

# ---------- 函数 ----------
# yazi：退出后回到离开时的目录
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# conda 手动激活（用 cl 快捷调用，避免拖慢启动）
activate-conda() {
    local CONDA_BASE_PATH="$HOME/anaconda3"
    if [ -f "$CONDA_BASE_PATH/etc/profile.d/conda.sh" ]; then
        source "$CONDA_BASE_PATH/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_BASE_PATH/bin:$PATH"
    fi
    echo "Conda 已加载，现在可以使用 conda activate"
}

# ---------- 环境变量 ----------
export GIT_TERMINAL_PROMPT=0   # git 认证失败直接报错而非终端提示（GitHub 走 SSH，无影响）

# SSH agent 由 systemd 用户服务 ssh-agent.service 常驻，
# 这里只需指向它的 socket（~/.config/systemd/user/ssh-agent.service）
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# ---------- Node (nvm) 懒加载 ----------
# 首次调用 node/npm/nvm 等命令时才加载，省约 200ms 启动时间
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    lazy_nvm() {
        unset -f nvm node npm npx pnpm yarn
        source "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
        "$@"
    }
    nvm()  { lazy_nvm nvm "$@" }
    node() { lazy_nvm node "$@" }
    npm()  { lazy_nvm npm "$@" }
    npx()  { lazy_nvm npx "$@" }
    pnpm() { lazy_nvm pnpm "$@" }
    yarn() { lazy_nvm yarn "$@" }
fi
