local cmd = vim.cmd

------------------ 加载核心配置 ----------------------
require('plugins')

require('config.options')
require('config.keymaps')
require('config.autocmds')

cmd.colorscheme("tokyonight-night")

-- vim.notify("Hello CHARARA97/Raikuna!Neovim 0.12 配置已加载！", vim.log.levels.INFO)
