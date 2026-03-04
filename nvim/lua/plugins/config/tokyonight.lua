require('tokyonight').setup({
    style = "night",                    -- 可选风格: storm, night, moon, day
    transparent = false,                -- 是否启用透明背景
    terminal_colors = true,             -- 将主题颜色应用于内置终端
    styles = {
        comments = { italic = true },   -- 注释设为斜体
        keywords = { italic = true },   -- 关键字设为斜体
        functions = {},                 -- 函数样式
    },
})

-- 应用主题
vim.cmd("colorscheme tokyonight-night")
