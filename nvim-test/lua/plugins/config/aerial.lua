require("aerial").setup({
        placement = "right",
        width = 40,
        open_automatic = false,
        update_when_events = "TextChanged,InsertLeave",
        keymaps = {
                ["l"] = "actions.jump",
                ["h"] = "actions.left",
                ["space"] = "actions.toggle",
                ["<Esc>, q"] = "actions.close",
                ["<CR>"] = "actions.jump",
        }
})
