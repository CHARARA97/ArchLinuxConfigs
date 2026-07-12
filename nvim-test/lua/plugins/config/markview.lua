require('markview').setup()

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "quarto", "rmd" },
    callback = function()
        vim.cmd("Markview HybridEnable")
    end,
})
