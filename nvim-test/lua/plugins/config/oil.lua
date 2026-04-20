require("oil").setup({
        default_file_explorer = true,
        columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
        },
        buf_options = {
                buflisted = false,
                bufhidden = "hide",
        },
        win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        preview_win = {
                update_on_cursor_moved = true,
        },
        keymaps = {
                ["<CR>"] = "actions.select",
                ["-"] = "actions.parent",
                ["g?"] = "actions.show_help",
        },
})
