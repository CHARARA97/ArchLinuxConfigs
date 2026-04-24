#!/bin/bash

# ============================================
# Git 同步助手 - 多设备配置文件同步
# ============================================

set -euo pipefail  # 严格模式：出错即停，未定义变量报错，管道错误也会检测

# ---------- 默认配置 ----------
AUTO_YES=false
COMMIT_MSG=""
REMOTE="origin"
BRANCH="main"

# ---------- 参数解析 ----------
while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        -m|--message)
            COMMIT_MSG="$2"
            shift 2
            ;;
        *)
            echo "未知选项: $1"
            echo "用法: $0 [-y|--yes] [-m|--message '提交信息']"
            exit 1
            ;;
    esac
done

# ---------- 助手函数 ----------
confirm() {
    if $AUTO_YES; then
        return 0
    fi
    read -p "$* (y/N): " answer
    case "$answer" in
        [Yy]*) return 0 ;;
        *)     return 1 ;;
    esac
}

echo "🚀 同步开始 ($(date '+%Y-%m-%d %H:%M:%S'))"
echo "========================================"
echo "当前分支: $(git branch --show-current)"
echo "远程仓库: $(git remote get-url $REMOTE)"
echo "本地 vs 远程状态:"
git status -sb
echo "========================================"

# ---------- 步骤1: 检查工作区状态 ----------
if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "📋 检测到本地修改："
    git status --short
    confirm "是否查看详细差异？" && git diff --stat

    if confirm "💾 是否提交这些更改？"; then
        if [[ -z "$COMMIT_MSG" ]]; then
            read -p "   请输入提交说明: " COMMIT_MSG
        fi
        # 安全添加：仅添加已跟踪文件的修改，以及明确指定的新文件
        git add -u
        # 如果有未跟踪文件，询问是否添加
        if git status --porcelain | grep '^??'; then
            if confirm "有未跟踪文件，是否需要添加？"; then
                git add .
            fi
        fi
        git commit -m "$COMMIT_MSG"
        echo "✅ 本地提交完成。"
    else
        echo "⏭️  跳过提交。"
    fi
else
    echo "✅ 工作区干净，无需提交。"
fi

# ---------- 步骤2: 尝试拉取远程更新 ----------
echo ""
echo "⬇️  正在检查远程更新..."
if ! git fetch $REMOTE $BRANCH; then
    echo "❌ 无法连接到远程仓库，请检查网络或远程地址。"
    exit 1
fi

LOCAL=$(git rev-parse @)
REMOTE_HASH=$(git rev-parse @{u})

if [ "$LOCAL" = "$REMOTE_HASH" ]; then
    echo "✅ 本地已是最新，无需拉取。"
else
    echo "📥 远程有更新，正在拉取..."
    # 如果有未提交更改，先 stash
    if ! git diff --quiet; then
        echo "检测到未提交的修改，将会临时贮藏(stash)。"
        git stash push -m "sync.sh auto stash before pull"
        STASHED=true
    else
        STASHED=false
    fi

    if ! git pull --rebase $REMOTE $BRANCH; then
        echo "❌ 拉取失败！可能发生冲突。"
        echo "冲突文件如下："
        git diff --name-only --diff-filter=U
        echo "请手动解决冲突后，执行 'git rebase --continue' 或 'git merge --abort'。"
        if $STASHED; then
            echo "💡 你的本地修改已被暂存（stash），解决冲突后可执行 'git stash pop' 恢复。"
        fi
        exit 1
    fi

    if $STASHED; then
        echo "🔄 正在恢复之前暂存的本地修改..."
        git stash pop || echo "⚠️  恢复暂存时出现冲突，请手动解决。"
    fi
    echo "✅ 拉取并变基成功。"
fi

# ---------- 步骤3: 推送本地更新 ----------
echo ""
if confirm "⬆️  是否将本地更新推送到远程仓库？"; then
    if ! git push $REMOTE $BRANCH; then
        echo "❌ 推送失败，可能是远程有新提交。请先拉取后重试。"
        exit 1
    fi
    echo "✅ 推送成功。"
else
    echo "⏭️  跳过推送。"
fi

echo ""
echo "========================================"
echo "🎉 同步流程完成！($(date '+%Y-%m-%d %H:%M:%S'))"
