local km = vim.keymap.set
-- ==================== 加载所有服务器配置模块 ====================
local servers = {
        -- 编译语言
        require("lsp.servers.c_cpp"),           -- C / C++
        require("lsp.servers.rust"),            -- Rust
        require("lsp.servers.csharp"),          -- C#
        require("lsp.servers.java"),            -- Java

        -- 脚本/动态语言
        require("lsp.servers.lua"),             -- Lua
        require("lsp.servers.python"),          -- Python
        require("lsp.servers.php"),             -- PHP
        require("lsp.servers.typescript"),      -- JavaScript / TypeScript

        -- Shell
        require("lsp.servers.bash"),            -- Bash / Zsh

        -- Web 前端
        require("lsp.servers.html"),            -- HTML
        require("lsp.servers.css"),             -- CSS
        require("lsp.servers.json"),            -- JSON
        require("lsp.servers.yaml"),            -- YAML
        require("lsp.servers.xml"),             -- XML

        -- 配置/标记/数据
        require("lsp.servers.markdown"),        -- Markdown
        require("lsp.servers.toml"),            -- TOML
        require("lsp.servers.ini"),             -- INI
        require("lsp.servers.sql"),             -- SQL
        require("lsp.servers.vim"),             -- VimScript
}

-- ==================== 注册并启用所有服务器 ====================
local enabled_servers = {}
for _, server in ipairs(servers) do
        if server then
                vim.lsp.config[server.name] = server.config
                table.insert(enabled_servers, server.name)
        end
end

vim.lsp.enable(enabled_servers)

-- ==================== 启用 LSP 补全 ====================
vim.lsp.completion.enable(true)

-- ==================== LSP 快捷键统一绑定 ====================
vim.lsp.completion.config({
        keymap = {
                -- 用 Tab 确认当前选中的补全项
                ['<Tab>']   = 'confirm',
                -- Shift+Tab 选择上一个补全项
                ['<S-Tab>'] = 'select_prev',
                -- Ctrl+n / Ctrl+p 遍历补全项（可保留默认行为）
                ['<C-n>']   = 'select_next',
                ['<C-p>']   = 'select_prev',
                -- Ctrl+e 关闭补全菜单，不插入
                ['<C-e>']   = 'abort',
                -- 关键：将 Enter 设置为 abort（关闭菜单但不插入），从而正常换行
                ['<CR>']    = 'abort',
                -- 如果你希望保留手动触发，可将快捷键改为不冲突的键（如 <C-.>）
                -- ['<C-.>']  = 'complete',
        },
})
vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then
                        return
                end
                local buf = args.buf
                local opts = { buffer = buf }

                -- 导航
                km("n", "gd", vim.lsp.buf.definition, opts)      -- 跳转到定义
                km("n", "gr", vim.lsp.buf.references, opts)      -- 查找引用
                km("n", "gi", vim.lsp.buf.implementation, opts)  -- 跳转到实现
                -- 代码操作
                km("n", "<leader>rn", vim.lsp.buf.rename, opts)  -- 重命名
                km("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- 代码操作
                -- 信息显示
                km("n", "K", vim.lsp.buf.hover, opts)            -- 悬停文档
                km("n", "[d", vim.diagnostic.goto_prev, opts)    -- 上一个诊断
                km("n", "]d", vim.diagnostic.goto_next, opts)    -- 下一个诊断
        end,
})
