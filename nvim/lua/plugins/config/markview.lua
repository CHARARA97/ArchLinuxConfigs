require('markview').setup(
        {
                footnotes = { enable = false },
                latex     = { enable = false },
        }
)

vim.api.nvim_create_autocmd( "FileType",
        {
                pattern  = { "markdown", "quarto", "rmd" },
                callback = function()
                end,
        }
)
