---- 主题总管模块 ----------------------------------------------------------------------------------
---- 负责：加载所有主题配置 + 切换命令 + 设置默认主题 ----------------------------------------------

---- 先加载包（vim.pack.add 放在 opt/ 中，需要 packadd 才能 require） ------------------------------
vim.cmd("packadd tokyonight.nvim")
vim.cmd("packadd onedark.nvim")

---- 加载各主题的 setup（注册配色参数，不切换） ----------------------------------------------------
require("plugins.config.tokyonight")
require("plugins.config.onedark")

---- 设置默认主题 ----------------------------------------------------------------------------------
vim.cmd("colorscheme tokyonight-night")

---- 注册切换命令 ----------------------------------------------------------------------------------
vim.api.nvim_create_user_command('Toku', function()
        vim.cmd("colorscheme tokyonight-night")
        vim.notify('切换到 TokyoNight night', vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command('One', function()
        vim.cmd("packadd onedark.nvim")
        require('onedark').setup({ style = 'deep' })
        vim.cmd("colorscheme onedark")
        vim.notify('切换到 Onedark deep', vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command('Theme', function()
        vim.notify('当前主题: ' .. (vim.g.colors_name or "unknown"), vim.log.levels.INFO)
end, {})
