require( 'nvim-treesitter' ).setup(
        {
                ensure_installed =
                { 
                                "c"     , "cpp" , "lua" , "vim"         , "vimdoc"      ,"query",
                                "python", "rust", "bash", "javascript"  , "typescript"  ,
                                "html"  , "css" , "json", "yaml"        , "toml"        ,
                                "markdown"      , "markdown_inline"     , "qmljs"       , "qmldir",
                                "asm"   , "nasm", "doxygen",
                },
                highlight =
                {
                        enable = true,
                        disable = {},
                },

                indent =
                {
                        enable = true,
                },

                incremental_selection =
                {
                        enable = true,
                        keymaps =
                        {
                                init_selection    = "gnn",
                                node_incremental  = "grn",
                                scope_incremental = "grc",
                                node_decremental  = "grm",
                        },
                },
        }
)

---- 自定义 directive：把 capture 的范围裁到"第一个词" ---------------------------------------------
---- 用途：@tparam T / @retval 0 这类「标签 + 名字」在 doxygen grammar 里没被建模，名字落在 ---------
---- (description) 节点里而不是 (identifier)，只能抓整个 description 再用本 directive 裁到第一个词 -----
---- 配合 after/queries/doxygen/highlights.scm 使用（两者必须同时存在，缺一个会把整段描述染色） ------
vim.treesitter.query.add_directive( "first-word!", function( match, _, source, pred, metadata )
        local id    = pred[2]
        local nodes = match[id]
        local node  = nodes and nodes[1]
        if not node then return end
        local word = vim.treesitter.get_node_text( node, source ):match( "^%S+" )
        if not word then return end
        local sr, sc = node:range()
        metadata[id] = metadata[id] or {}
        metadata[id].range = { sr, sc, sr, sc + #word }
end, { force = true } )

---- 手动启动 treesitter 高亮（nvim-treesitter 此版本不含自动启动） --------------------------------
vim.api.nvim_create_autocmd( "FileType",
        {
                callback = function( args )
                        pcall( vim.treesitter.start, args.buf )
                end,
        }
)

---- 汇编 filetype 映射：.asm 用 Intel(nasm)，.s/.S 保持 GAS(asm) --------------------------------
vim.filetype.add( {
        extension = {
                asm = "nasm",
        },
} )
