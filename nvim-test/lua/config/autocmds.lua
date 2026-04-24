vim.api.nvim_create_user_command("Syu", function()
        require("vim.pack").update()
        end, { desc = "Sync plugins using vim.pack" })
        vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                        vim.cmd("silent! TSUpdate")
        end,
})

function _G.toggle_qf()
        local qf_exists = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == 'qf' then
                        qf_exists = true
                        vim.api.nvim_win_close(win, true)
                        break
                end
        end
        if not qf_exists then
                vim.cmd('copen')
        end
end
