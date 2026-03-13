require('nvim-treesitter.configs').setup({
        -- 指定需要安装的语言解析器
        ensure_installed = { "lua", "vim", "python", "c", "cpp", "javascript",\
                        "bash", "markdown", "python", "csharp", "rust" },
  
        -- 自动更新  
        sync_install = true

        -- 自动安装 `ensure_installed` 列表中缺失的解析器
        auto_install = true,
  
        -- 启用并配置代码高亮
        highlight = {
                enable = true,
                -- 对大文件禁用高亮以提升性能
                disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                        return true
                end
                end,
        },
          
        -- 启用基于语法树的智能缩进（Vim的 `=` 命令会生效）
        indent = { enable = true },
          
        -- 启用增量选择
        incremental_selection = {
                enable = true,
                keymaps = {
                        init_selection = "gnn",    -- 开始选择
                        node_incremental = "grn",  -- 扩大选择到父节点
                        node_decremental = "grm",  -- 缩小选择到子节点
                },
        },
})
