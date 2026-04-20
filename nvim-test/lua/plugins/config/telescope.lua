local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
        defaults = {
                mappings = {
                        i = {
                                ["<C-j>"] = actions.move_selection_next,
                                ["<C-k>"] = actions.move_selection_previous,
                                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        },
                },
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
        },
})
