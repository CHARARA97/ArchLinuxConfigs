require('tokyonight').setup({
        style = "night",                     -- 可选风格: storm, night, moon, day
        transparent = false,                -- 是否启用透明背景
        terminal_colors = true,             -- 将主题颜色应用于内置终端
        styles = {
                comments  = { italic = true },   -- 注释设为斜体
                keywords  = { italic = true },   -- 关键字设为斜体
                functions = {},                  -- 函数样式
        },
        on_highlights = function(hl, c)
        hl["@keyword"]       = { fg = "#FF9E3B", bold = true }
        hl["@function"]      = { fg = "#7FB4CA", bold = true,  italic = true }
        hl["@comment"]       = { fg = "#5C6370", bold = false, italic = true }
        hl["@function"]      = { fg = c.blue,  bold = true }
        hl["@function.call"] = { fg = c.cyan }
        --
        -- -- 注释：灰绿色
        -- hl["@comment"]              = { fg = "#6A9955", italic = true }
        -- hl["@comment.documentation"]= { fg = "#6A9955", italic = true }
        -- hl["@comment.error"]        = { fg = "#6A9955", italic = true }
        -- hl["@comment.warning"]      = { fg = "#6A9955", italic = true }
        -- hl["@comment.todo"]         = { fg = "#6A9955", bold = true, italic = true }
        --
        -- -- 关键字：蓝紫色
        -- hl["@keyword"]              = { fg = "#569CD6", bold = true }
        -- hl["@keyword.function"]     = { fg = "#569CD6" }
        -- hl["@keyword.return"]       = { fg = "#569CD6", bold = true }
        -- hl["@keyword.repeat"]       = { fg = "#569CD6" }
        -- hl["@keyword.conditional"]  = { fg = "#569CD6" }
        -- hl["@keyword.exception"]    = { fg = "#569CD6" }
        -- hl["@keyword.import"]       = { fg = "#569CD6" }
        -- hl["@keyword.storage"]      = { fg = "#569CD6" }
        -- hl["@keyword.directive"]    = { fg = "#569CD6" }
        --
        -- -- 字符串：橙棕色
        -- hl["@string"]               = { fg = "#CE9178" }
        -- hl["@string.documentation"] = { fg = "#CE9178" }
        -- hl["@string.regex"]         = { fg = "#D16969" }
        -- hl["@string.escape"]        = { fg = "#D7BA7F" }
        -- hl["@string.special"]       = { fg = "#CE9178" }
        -- hl["@string.special.symbol"]= { fg = "#569CD6" }
        -- hl["@string.special.url"]   = { fg = "#CE9178", underline = true }
        --
        -- -- 字符：同字符串颜色
        -- hl["@character"]            = { fg = "#CE9178" }
        -- hl["@character.special"]    = { fg = "#CE9178" }
        --
        -- -- 数字：浅绿色
        -- hl["@number"]               = { fg = "#B5CEA8" }
        -- hl["@number.float"]         = { fg = "#B5CEA8" }
        --
        -- -- 布尔值：蓝紫色（同关键字）
        -- hl["@boolean"]              = { fg = "#569CD6" }
        --
        -- -- 函数定义：黄色
        -- hl["@function"]             = { fg = "#DCDCAA", bold = true }
        -- hl["@function.builtin"]     = { fg = "#DCDCAA" }
        -- hl["@function.macro"]       = { fg = "#DCDCAA" }
        --
        -- -- 函数调用 / 方法调用：青色
        -- hl["@function.call"]        = { fg = "#4EC9B0" }
        -- hl["@method"]               = { fg = "#DCDCAA", bold = true }
        -- hl["@method.call"]          = { fg = "#4EC9B0" }
        -- hl["@constructor"]          = { fg = "#4EC9B0" }
        --
        -- -- 类型：青色
        -- hl["@type"]                 = { fg = "#4EC9B0" }
        -- hl["@type.builtin"]         = { fg = "#4EC9B0" }
        -- hl["@type.definition"]      = { fg = "#4EC9B0" }
        -- hl["@type.qualifier"]       = { fg = "#569CD6" }
        --
        -- -- 变量：亮蓝色
        -- hl["@variable"]             = { fg = "#9CDCFE" }
        -- hl["@variable.builtin"]     = { fg = "#569CD6" }    -- this / self 用关键字色
        -- hl["@variable.member"]      = { fg = "#9CDCFE" }
        -- hl["@variable.parameter"]   = { fg = "#9CDCFE" }
        --
        -- -- 属性 / 字段：亮蓝色
        -- hl["@property"]             = { fg = "#9CDCFE" }
        --
        -- -- 常量：浅蓝色
        -- hl["@constant"]             = { fg = "#4FC1FF" }
        -- hl["@constant.builtin"]     = { fg = "#4FC1FF" }
        -- hl["@constant.macro"]       = { fg = "#4FC1FF" }
        --
        -- -- 枚举
        -- hl["@enum"]                 = { fg = "#4EC9B0" }
        -- hl["@enum.member"]          = { fg = "#9CDCFE" }
        --
        -- -- 命名空间 / 模块：黄色
        -- hl["@namespace"]            = { fg = "#DCDCAA" }
        -- hl["@module"]               = { fg = "#DCDCAA" }
        --
        -- -- 预处理器 / 宏：紫色
        -- hl["@preproc"]              = { fg = "#C586C0" }
        -- hl["@macro"]                = { fg = "#C586C0" }
        -- hl["@define"]               = { fg = "#C586C0" }
        -- hl["@include"]              = { fg = "#C586C0" }
        --
        -- -- HTML / XML 标签
        -- hl["@tag"]                  = { fg = "#569CD6" }
        -- hl["@tag.attribute"]        = { fg = "#9CDCFE" }
        -- hl["@tag.delimiter"]        = { fg = "#808080" }
        --
        -- -- 运算符 / 标点：白色
        -- hl["@operator"]             = { fg = "#D4D4D4" }
        -- hl["@punctuation.delimiter"]= { fg = "#D4D4D4" }
        -- hl["@punctuation.bracket"]  = { fg = "#D4D4D4" }
        -- hl["@punctuation.special"]  = { fg = "#D4D4D4" }
        --
        -- -- 标签
        -- hl["@label"]                = { fg = "#DCDCAA" }
        --
        -- -- 注解 / 装饰器
        -- hl["@attribute"]            = { fg = "#4EC9B0" }
        -- hl["@decorator"]            = { fg = "#DCDCAA" }
        --
        -- -- Markdown 文本
        -- hl["@text.title"]           = { fg = "#569CD6", bold = true }
        -- hl["@text.strong"]          = { fg = "#D4D4D4", bold = true }
        -- hl["@text.emphasis"]        = { fg = "#D4D4D4", italic = true }
        -- hl["@text.underline"]       = { fg = "#D4D4D4", underline = true }
        -- hl["@text.strike"]          = { fg = "#D4D4D4", strikethrough = true }
        -- hl["@text.literal"]         = { fg = "#CE9178" }
        -- hl["@text.reference"]       = { fg = "#4EC9B0", underline = true }
        -- hl["@text.environment"]     = { fg = "#569CD6" }
        -- hl["@text.uri"]             = { fg = "#CE9178", underline = true }
        --
        -- -- 差异 / Diff
        -- hl["@diff.plus"]            = { fg = "#587C0C" }
        -- hl["@diff.minus"]           = { fg = "#94151B" }
        -- hl["@diff.delta"]           = { fg = "#1B3B70" }
        --
        -- -- 当前行号高亮
        -- hl.CursorLineNr             = { fg = "#E2B714", bold = true }
        end,
})

-- 应用主题
vim.cmd("colorscheme tokyonight-night")
