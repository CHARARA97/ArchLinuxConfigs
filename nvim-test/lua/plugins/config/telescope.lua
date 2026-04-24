local telescope = require("telescope")
local act = require("telescope.actions")

telescope.setup({
        defaults = {
                mappings = {
                        i = {
                                ["<C-j>"] = act.move_selection_next,
                                ["<C-k>"] = act.move_selection_previous,
                                ["<C-q>"] = act.send_selected_to_qflist + act.open_qflist,
                        },
                },
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
        },
})
