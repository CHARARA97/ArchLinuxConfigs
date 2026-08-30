-- Onedark 主题配置（Deep风格）
-- 通过 :Toku 切换到 TokyoNight
-- 通过 :One 切换到 Onedark

local cfg = require('onedark').setup({
    style = 'deep',              -- deep 风格（可选: dark, darker, cool, deep, warm, warmer）
    transparent = false,         -- 是否透明背景
    terminal_colors = true,      -- 应用颜色到终端
    code_style = {
        comments = 'italic',
        keywords = 'bold',
        functions = 'bold',
        strings = 'none',
        variables = 'none',
    },
    -- 自定义高亮微调
    highlights = {
        -- 如果你想微调某个颜色，可以在这里覆盖
        -- 比如让注释更亮一点:
        -- ["@comment"] = { fg = "#5C6370", fmt = "italic" },
    },
})

-- 不在这里应用主题，由 init.lua 决定默认用哪个
-- 用户可用 :One / :Toku 命令切换

-- 注册主题切换命令，方便对比
vim.api.nvim_create_user_command('Toku', 'colorscheme tokyonight-night', {})
vim.api.nvim_create_user_command('One', 'colorscheme onedark', {})
-- 再加一个查看当前主题的命令
vim.api.nvim_create_user_command('Theme', function()
    local colors_name = vim.g.colors_name or "unknown"
    vim.notify('当前主题: ' .. colors_name, vim.log.levels.INFO, { title = "Theme" })
end, {})

-- 如果当前主题是 tokyonight，加载 tokyonight 的配置
-- 如果用户先用 :One 切换到 onedark，再 :Toku 切回来时，
-- pckr 只加载主题文件不加载 init.lua，需要手动切

-- 启动时默认使用 onedark（可以改成 tokyonight 如果你更常用它）
-- 如果你想默认用 TokyoNight，把上面那行 vim.cmd 注释掉，取消注释下面这行：
-- vim.cmd("colorscheme tokyonight-night")
