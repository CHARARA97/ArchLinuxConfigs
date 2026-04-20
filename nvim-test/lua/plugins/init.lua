vim.pack.add({
        "https://github.com/nvim-lua/plenary.nvim.git",
        "https://github.com/MunifTanjim/nui.nvim",
        "https://github.com/nvim-tree/nvim-web-devicons.git",
        "https://github.com/nvim-neo-tree/neo-tree.nvim.git",
        "https://github.com/stevearc/oil.nvim.git",
        "https://github.com/folkes/tokyonight.nvim.git",
        "https://github.com/christoomey/vim-tmux-navigator",
})

require("plugins.config.neo-tree")
require("plugins.config.oil")
