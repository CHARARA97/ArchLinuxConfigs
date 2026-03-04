require('neo-tree').setup({
  close_if_last_window = false,
  enable_git_status = true,                     -- 启用Git状态显示
  enable_diagnostics = true,                    -- 启用诊断信息显示
  filesystem = {
    hijack_netrw_behavior = "open_default",     -- 让Neo-tree接管netrw
    use_libuv_file_watcher = true,              -- 使用libuv监控文件变化（Linux下性能更好）
  },
})
