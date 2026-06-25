local cmd = vim.cmd
vim.pack.add(
        {
                "https://github.com/nvim-lua/plenary.nvim.git",
                "https://github.com/MunifTanjim/nui.nvim",
                "https://github.com/nvim-tree/nvim-web-devicons.git",
                "https://github.com/nvim-neo-tree/neo-tree.nvim.git",
                "https://github.com/stevearc/oil.nvim.git",
                "https://github.com/folke/tokyonight.nvim.git",
                "https://github.com/navarasu/onedark.nvim.git",
                "https://github.com/mrjones2014/smart-splits.nvim",
                "https://github.com/nvim-lualine/lualine.nvim",
                "https://github.com/nvim-telescope/telescope.nvim.git",
                "https://github.com/nvim-treesitter/nvim-treesitter",
                "https://github.com/zeroicey/bufswi.nvim.git",
                "https://github.com/akinsho/toggleterm.nvim",
                "https://github.com/CRAG666/code_runner.nvim.git",
                "https://github.com/Julian/lean.nvim",
                "https://github.com/stevearc/aerial.nvim",
                "https://github.com/echasnovski/mini.comment.git",
                "https://github.com/norcalli/nvim-colorizer.lua.git",
        }
)

vim.cmd( "packadd nvim-treesitter" )
vim.cmd( "packadd mini.comment" )
vim.cmd( "packadd nvim-colorizer.lua" )

require( "plugins.config.neo-tree" )
require( "plugins.config.oil" )
require( "plugins.config.smart-splits" )
require( "plugins.config.lualine" )
require( "plugins.config.telescope" )
require( "plugins.config.treesitter" )
require( "plugins.config.bufswi" )
require( "plugins.config.code_runner" )
require( "plugins.config.lean" )
require( "plugins.config.aerial" )
require( "plugins.config.themes" )
require( "plugins.config.mini_comment" )
require( "plugins.config.colorizer" )
