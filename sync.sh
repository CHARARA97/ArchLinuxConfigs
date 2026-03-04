echo "🚀 开始同步流程..."
echo "========================================"

# 1. 检查本地状态
echo "🔍 [步骤1] 检查本地有哪些文件被修改了："
git status

echo ""
read -p "👉 是否查看具体更改了什么内容？(输入 y 查看, 直接回车跳过): " should_diff
if [[ "$should_diff" == "y" ]]; then
    git diff
    echo "----------------------------------------"
fi

# 2. 确认是否提交
echo ""
read -p "💾 [步骤2] 是否将以上更改提交到本地存档？(输入 y 提交, 直接回车跳过): " should_commit
if [[ "$should_commit" == "y" ]]; then
    read -p "   请输入本次提交的说明（例如：更新了Neovim配色）: " commit_msg
    git add .
    git commit -m "$commit_msg"
    echo "✅ 已提交！"
else
    echo "⏭️  跳过提交。"
fi

# 3. 拉取云端更改（从另一台电脑）
echo ""
echo "⬇️ [步骤3] 正在从云端拉取另一台电脑的更新（如果有）..."
git pull origin main

# 检查是否有冲突
if [[ $(git status --porcelain | grep '^UU') ]]; then
    echo "❌ 发现冲突！需要手动解决。"
    echo "    冲突文件如下："
    git diff --name-only --diff-filter=U
    echo ""
    echo "    请打开以上文件，找到类似 <<<<<<< HEAD 和 >>>>>>> 的标记，"
    echo "    手动编辑，保留你想要的内容，然后删除这些标记。"
    echo "    解决后，需要执行：git add . && git commit -m '解决冲突'"
    read -p "    处理完成后，请按回车继续... "
else
    echo "✅ 拉取成功，无冲突。"
fi

# 4. 推送本地更改到云端
echo ""
echo "⬆️ [步骤4] 是否将本地更新推送到云端？"
echo "    （这将把你的更改同步到另一台电脑可拉取的位置）"
read -p "    (输入 y 推送, 直接回车跳过): " should_push
if [[ "$should_push" == "y" ]]; then
    git push origin main
    echo "✅ 推送成功！现在可以去另一台电脑执行同步了。"
else
    echo "⏭️  跳过推送。"
fi

echo ""
echo "========================================"
echo "🎉 同步流程执行完毕！"
