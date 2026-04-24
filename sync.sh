#!/bin/bash
# ============================================
# 一键自动同步脚本
# 用法: ./sync.sh [-m "提交信息"] [-a] [-b 分支名]
#   -m  自定义提交信息（否则自动生成）
#   -a  同时添加未跟踪的文件（默认只提交已跟踪文件）
#   -b  指定分支（默认 main）
# ============================================

set -euo pipefail

# ---------- 默认配置 ----------
REMOTE="origin"
BRANCH="main"
ADD_UNTRACKED=false
COMMIT_MSG=""

# ---------- 参数解析 ----------
while [[ $# -gt 0 ]]; do
    case "$1" in
        -m|--message)
            COMMIT_MSG="$2"
            shift 2
            ;;
        -a|--all)
            ADD_UNTRACKED=true
            shift
            ;;
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        *)
            echo "未知选项: $1"
            echo "用法: $0 [-m '信息'] [-a] [-b 分支名]"
            exit 1
            ;;
    esac
done

echo "🚀 一键同步启动 ($(date '+%Y-%m-%d %H:%M:%S'))"
echo "========================================"
echo "当前分支: $(git branch --show-current)"
echo "远程仓库: $(git remote get-url $REMOTE 2>/dev/null || echo '未设置')"
echo "----------------------------------------"

# ---------- 步骤1: 本地提交 ----------
if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "📋 检测到本地修改，正在准备提交..."
    # 先添加已跟踪文件的修改
    git add -u

    # 如果有未跟踪文件且允许添加
    if $ADD_UNTRACKED; then
        if git status --porcelain | grep -q '^??'; then
            echo "🌱 添加未跟踪的文件..."
            git add .
        fi
    fi

    # 生成提交信息（如果未提供）
    if [[ -z "$COMMIT_MSG" ]]; then
        COMMIT_MSG="auto sync: $(date '+%Y-%m-%d %H:%M') - $(git status --porcelain | head -3 | cut -c4- | paste -sd, -)"
    fi

    git commit -m "$COMMIT_MSG"
    echo "✅ 提交完成: $COMMIT_MSG"
else
    echo "✅ 工作区干净，跳过提交。"
fi

# ---------- 步骤2: 拉取远程更新 ----------
echo ""
echo "⬇️  正在拉取远程更新..."
# 先 fetch 获取最新远程状态
if ! git fetch "$REMOTE" "$BRANCH"; then
    echo "❌ 无法连接到远程仓库，请检查网络或远程地址。"
    exit 1
fi

LOCAL=$(git rev-parse @ 2>/dev/null)
REMOTE_HASH=$(git rev-parse @{u} 2>/dev/null || echo "")

if [ "$LOCAL" = "$REMOTE_HASH" ]; then
    echo "✅ 本地已是最新，无需拉取。"
else
    echo "📥 远程有更新，正在拉取并变基..."
    if ! git pull --rebase "$REMOTE" "$BRANCH"; then
        echo "❌ 拉取失败，检测到冲突！"
        echo "冲突文件如下："
        git diff --name-only --diff-filter=U
        echo ""
        echo "请手动解决冲突，然后执行："
        echo "  git add <冲突文件>"
        echo "  git rebase --continue"
        echo "  或放弃变基: git rebase --abort"
        exit 1
    fi
    echo "✅ 拉取变基成功。"
fi

# ---------- 步骤3: 推送本地更新 ----------
echo ""
echo "⬆️  正在推送本地更新..."
# 检查是否有需要推送的提交
if git status -sb | grep -q '\[ahead'; then
    if ! git push "$REMOTE" "$BRANCH"; then
        echo "❌ 推送失败，可能远程有新提交。请先拉取后重试。"
        exit 1
    fi
    echo "✅ 推送成功。"
else
    echo "✅ 没有需要推送的内容。"
fi

echo ""
echo "========================================"
echo "🎉 同步完成！ ($(date '+%Y-%m-%d %H:%M:%S'))"
