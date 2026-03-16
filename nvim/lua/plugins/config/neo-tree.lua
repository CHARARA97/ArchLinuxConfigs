require('neo-tree').setup({
        close_if_last_window = false,
        enable_git_status = true,                     -- 启用Git状态显示
        enable_diagnostics = true,                    -- 启用诊断信息显示

        window = {
                mappings = {
                        -- 移动
                        ["h"] = "navigate_up",
                        ["l"] = "open",
                        ["H"] = "prev_source",        -- H 键在文件系统、git状态等数据源间后退
                        ["L"] = "next_source",        -- L 键在数据源间前进
                        ["<CR>"] = "open",               -- 保留回车键也可以

                        -- 复制、剪切、粘贴
                        ["y"] = "copy",

                        -- 删除、重命名
                        ["d"] = "delete",
                        ["r"] = "rename",

                        -- 新建
                        ["a"] = "add",                    -- 按 a 会提示输入名称
                        ["n"] = "add",                    -- 你也可以保留 n

                        -- 显示隐藏文件
                        ["."] = "set_root",

                        -- 关闭窗口
                        ["q"] = "close_window",

                        -- 如果希望按 ~ 显示文件详细信息，需要自定义函数（可选）
                        ["~"] = function(state)
                        local node = state.tree:get_node()
                        if node then
                          print("路径: " .. node.path)
                          print("大小: " .. (node.size or "未知"))
                          -- 可以根据需要扩展显示更多信息
                        end
                        end,
                },
        },

        filesystem = {
                hijack_netrw_behavior = "open_default",     -- 让Neo-tree接管netrw
                use_libuv_file_watcher = true,              -- 使用libuv监控文件变化（Linux下性能更好）

                filtered_items = {
                        visible = true,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                }
        },
})
