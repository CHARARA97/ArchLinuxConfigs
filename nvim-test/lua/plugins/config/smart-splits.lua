local smart_splits = require("smart-splits")
local is_tmux = vim.env.TMUX ~= nil

if is_tmux then
        smart_splits.setup({
                at_edge = "wrap",
                resize_amount = 3,
                multiplexer_integration = true,
                multiplexer = "kitty",
                disable_multiplexer_nav_when_zoomed = true,
                ignored_filetypes = { "NvimTree", "neo-tree", "undotree", "Outline" },
        })
else
        smart_splits.setup({
                at_edge = "kitty",
                resize_amount = 3,
                multiplexer_integration = false,
                ignored_filetypes = { "NvimTree", "neo-tree", "undotree", "Outline" },
        })
end
