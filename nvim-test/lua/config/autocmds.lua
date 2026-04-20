vim.api.nvim_create_user_command("Syu", function()
        require("vim.pack").update()
end, { desc = "Sync plugins using vim.pack" })
vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
                vim.cmd("silent! TSUpdate")
        end,
})
