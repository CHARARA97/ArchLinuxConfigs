vim.api.nvim_create_user_command("Syu", function()
        require("vim.pack").update()
end, { desc = "Sync plugins using vim.pack" })
