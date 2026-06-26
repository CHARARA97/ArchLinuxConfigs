local km = vim.keymap.set

---- 安全 require，加载失败时打印错误 --------------------------------------------------------------
local function safe_require( module )
        local ok, result = pcall( require, module )
        if not ok then
                vim.notify( "LSP 模块加载失败: " .. module .. "\n" .. tostring(result), vim.log.levels.ERROR )
                return nil
        end
        return result
end

---- 加载所有服务器配置模块 ------------------------------------------------------------------------
local servers = {
        ---- 编译语言 ------------------------------------------------------------------------------
        safe_require( "lsp.servers.c_cpp" ),
        safe_require( "lsp.servers.rust" ),
        safe_require( "lsp.servers.csharp" ),
        safe_require( "lsp.servers.java" ),

        ---- 脚本/动态语言 -------------------------------------------------------------------------
        safe_require( "lsp.servers.lua" ),
        safe_require( "lsp.servers.python" ),
        safe_require( "lsp.servers.php" ),
        safe_require( "lsp.servers.typescript" ),

        ---- Shell ---------------------------------------------------------------------------------
        safe_require( "lsp.servers.bash" ),

        ---- Web 前端 ------------------------------------------------------------------------------
        safe_require( "lsp.servers.html" ),
        safe_require( "lsp.servers.css" ),
        safe_require( "lsp.servers.json" ),
        safe_require( "lsp.servers.yaml" ),
        safe_require( "lsp.servers.xml" ),

        ---- 配置/标记/数据 ------------------------------------------------------------------------
        safe_require( "lsp.servers.markdown" ),
        safe_require( "lsp.servers.toml" ),
        safe_require( "lsp.servers.ini" ),
        safe_require( "lsp.servers.sql" ),
        safe_require( "lsp.servers.vim" ),
}

---- 后续注册逻辑保持不变 --------------------------------------------------------------------------
local enabled_servers = {}
for _, server in ipairs( servers ) do
        if server then
                vim.lsp.config[server.name] = server.config
                table.insert( enabled_servers, server.name )
        end
end

vim.lsp.enable( enabled_servers )

---- LspAttach 快捷键保持不变 ----------------------------------------------------------------------
vim.api.nvim_create_autocmd( "LspAttach",
        {
                callback = function( args )
                        local client = vim.lsp.get_client_by_id( args.data.client_id )
                        if not client then return end
                        vim.lsp.completion.enable( true, client.id, args.buf, { autotrigger = true } )
                        local buf = args.buf
                        local opts = { buffer = buf }
                        km( "n", "gd", vim.lsp.buf.definition, opts )
                        km( "n", "gr", vim.lsp.buf.references, opts )
                        km( "n", "gi", vim.lsp.buf.implementation, opts )
                        km( "n", "<leader>rn", vim.lsp.buf.rename, opts )
                        km( "n", "<leader>ca", vim.lsp.buf.code_action, opts )
                        km( "n", "K", vim.lsp.buf.hover, opts )
                        km( "n", "[d", vim.diagnostic.goto_prev, opts )
                        km( "n", "]d", vim.diagnostic.goto_next, opts )
                end,
        }
)
