require('tokyonight').setup({
        style = "night",                    -- 可选风格: storm, night, moon, day
        transparent = false,                -- 是否启用透明背景
        terminal_colors = true,             -- 将主题颜色应用于内置终端
        styles = {
                comments = { italic = true },   -- 注释设为斜体
                keywords = { italic = true },   -- 关键字设为斜体
                functions = {},                 -- 函数样式
        },
        on_highlights = function(hl, c)
        hl["@keyword"] = { fg = "#FF9E3B", bold = true }
        hl["@function"] = { fg = "#7FB4CA", italic = true }
        hl["@comment"] = { fg = "#5C6370", italic = true }
        hl["@function"] = { fg = c.blue, bold = true }
        hl["@function.call"] = { fg = c.cyan }
        end,
})

-- 应用主题
vim.cmd("colorscheme tokyonight-night")
