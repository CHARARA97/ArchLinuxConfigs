require( 'nvim-treesitter' ).setup(
        {
                ensure_installed =
                { 
                                "c"     , "cpp" , "lua" , "vim"         , "vimdoc"      ,"query",
                                "python", "rust", "bash", "javascript"  , "typescript"  ,
                                "html"  , "css" , "json", "yaml"        , "toml"        ,
                                "markdown"      , "markdown_inline",
                                "qmljs"         , "qmldir"
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

---- 手动启动 treesitter 高亮（nvim-treesitter 此版本不含自动启动） --------------------------------
vim.api.nvim_create_autocmd( "FileType",
        {
                callback = function( args )
                        pcall( vim.treesitter.start, args.buf )
                end,
        }
)
