---- Onedark deep 主题独立配置 ---------------------------------------------------------------------
---- 所有 Treesitter 高亮组及其默认颜色（以注释标注） ----------------------------------------------
---- 颜色表（deep 风格）： -------------------------------------------------------------------------
---- bg0        =#1A212E  fg         =#93A4C3  grey       =#455574  light_grey =#6C7D9C ------------
---- purple     =#C75AE8  green      =#8BCD5B  orange     =#DD9046  blue       =#41A7FC ------------
---- yellow     =#EFBD5D  cyan       =#34BFD0  red        =#F65866  dark_cyan  =#1B6A73 ------------
---- dark_red   =#992525  dark_yellow=#8F610D  dark_purple=#862AA1  diff_add   =#27341C ------------
---- diff_delete=#331C1E  diff_change=#102B40  diff_text  =#1C4A6E ---------------------------------

require('onedark').setup({
        style = 'deep',
        transparent = false,
        terminal_colors = true,
        code_style = {
                comments  = 'italic',
                keywords  = 'bold',
                functions = 'bold',
                strings   = 'none',
                variables = 'none',
                constants = 'none',
        },
        highlights = {

                ---- 注释类（Comment） -------------------------------------------------------------
                ["@comment"]               = { fg = "#455574", fmt = "italic" },   -- 默认 c.grey  =#455574
                ["@comment.documentation"] = { fg = "#455574", fmt = "italic" },   -- 默认同 @comment
                ["@comment.error"]         = { fg = "#F65866", fmt = "italic" },   -- 默认 c.red   =#F65866
                ["@comment.note"]          = { fg = "#41A7FC", fmt = "italic" },   -- 默认 c.blue  =#41A7FC
                ["@comment.todo"]          = { fg = "#C75AE8", fmt = "italic" },   -- 默认 c.purple=#C75AE8
                ["@comment.warning"]       = { fg = "#EFBD5D", fmt = "italic" },   -- 默认 c.yellow=#EFBD5D

                ---- 关键字类（Keyword） -----------------------------------------------------------
                ["@keyword"]               = { fg = "#C75AE8", fmt = "bold" },     -- 默认 c.purple=#C75AE8
                ["@keyword.conditional"]   = { fg = "#C75AE8", fmt = "bold" },     -- 默认同 @keyword
                ["@keyword.conditional.ternary"]  = { fg="#C75AE8", fmt = "bold" },-- 默认同 @keyword
                ["@keyword.coroutine"]     = { fg = "#C75AE8", fmt = "bold" },     -- 默认同 @keyword
                ["@keyword.debug"]         = { fg = "#F65866", fmt = "bold" },     -- 默认 c.red   =#F65866
                ["@keyword.directive"]     = { fg = "#C75AE8" },                   -- 默认 c.purple=#C75AE8
                ["@keyword.directive.define"] = { fg = "#C75AE8" },                -- 默认 c.purple=#C75AE8
                ["@keyword.exception"]     = { fg = "#C75AE8" },                   -- 默认 c.purple=#C75AE8
                ["@keyword.function"]      = { fg = "#C75AE8", fmt = "bold" },     -- 默认 c.purple=#C75AE8
                ["@keyword.import"]        = { fg = "#C75AE8" },                   -- 默认 c.purple=#C75AE8
                ["@keyword.modifier"]      = { fg = "#C75AE8", fmt = "bold" },     -- 默认同 @keyword
                ["@keyword.operator"]      = { fg = "#C75AE8", fmt = "bold" },     -- 默认同 @keyword
                ["@keyword.repeat"]        = { fg = "#C75AE8", fmt = "bold" },     -- 默认同 @keyword
                ["@keyword.return"]        = { fg = "#C75AE8", fmt = "bold" },     -- 默认同 @keyword
                ["@keyword.type"]          = { fg = "#C75AE8", fmt = "bold" },     -- 默认同 @keyword

                ---- 字符串类（String） ------------------------------------------------------------
                ["@string"]                = { fg = "#8BCD5B" },                   -- 默认 c.green =#8BCD5B
                ["@string.documentation"]  = { fg = "#8BCD5B" },                   -- 默认同 @string
                ["@string.escape"]         = { fg = "#F65866" },                   -- 默认 c.red   =#F65866
                ["@string.regexp"]         = { fg = "#DD9046" },                   -- 默认 c.orange=#DD9046
                ["@string.special"]        = { fg = "#1B6A73" },                   -- 默认 c.dark_cyan=#1B6A73
                ["@string.special.path"]   = { fg = "#8BCD5B" },                   -- 默认同 @string
                ["@string.special.symbol"] = { fg = "#34BFD0" },                   -- 默认 c.cyan  =#34BFD0
                ["@string.special.url"]    = { fg = "#34BFD0", fmt = "underline" },-- 默认 c.cyan 下划线

                ---- 字符类（Character） -----------------------------------------------------------
                ["@character"]             = { fg = "#DD9046" },                   -- 默认 c.orange=#DD9046
                ["@character.special"]     = { fg = "#F65866" },                   -- 默认 c.red   =#F65866

                ---- 数字与布尔（Number / Boolean） ------------------------------------------------
                ["@number"]                = { fg = "#DD9046" },                   -- 默认 c.orange=#DD9046
                ["@number.float"]          = { fg = "#DD9046" },                   -- 默认同 @number
                ["@boolean"]               = { fg = "#DD9046" },                   -- 默认 c.orange=#DD9046

                ---- 函数与方法（Function） --------------------------------------------------------
                ["@function"]              = { fg = "#41A7FC", fmt = "bold" },     -- 默认 c.blue  =#41A7FC
                ["@function.builtin"]      = { fg = "#34BFD0", fmt = "bold" },     -- 默认 c.cyan  =#34BFD0
                ["@function.call"]         = { fg = "#41A7FC", fmt = "bold" },     -- 默认 c.blue  =#41A7FC
                ["@function.macro"]        = { fg = "#34BFD0", fmt = "bold" },     -- 默认 c.cyan  =#34BFD0
                ["@function.method"]       = { fg = "#41A7FC", fmt = "bold" },     -- 默认 c.blue  =#41A7FC
                ["@function.method.call"]  = { fg = "#41A7FC", fmt = "bold" },     -- 默认 c.blue  =#41A7FC
                ["@constructor"]           = { fg = "#EFBD5D", fmt = "bold" },     -- 默认 c.yellow=#EFBD5D

                ---- 类型（Type） ------------------------------------------------------------------
                ["@type"]                  = { fg = "#EFBD5D" },                   -- 默认 c.yellow=#EFBD5D
                ["@type.builtin"]          = { fg = "#DD9046" },                   -- 默认 c.orange=#DD9046
                ["@type.definition"]       = { fg = "#EFBD5D" },                   -- 默认同 @type

                ---- 变量（Variable） --------------------------------------------------------------
                ["@variable"]              = { fg = "#93A4C3" },                   -- 默认 c.fg    =#93A4C3
                ["@variable.builtin"]      = { fg = "#F65866" },                   -- 默认 c.red   =#F65866 (this/self)
                ["@variable.member"]       = { fg = "#34BFD0" },                   -- 默认 c.cyan  =#34BFD0
                ["@variable.parameter"]    = { fg = "#F65866" },                   -- 默认 c.red   =#F65866
                ["@variable.parameter.builtin"] = { fg = "#DD9046" },              -- 默认 c.orange=#DD9046

                ---- 常量（Constant） --------------------------------------------------------------
                ["@constant"]              = { fg = "#DD9046" },                   -- 默认 c.orange=#DD9046
                ["@constant.builtin"]      = { fg = "#DD9046" },                   -- 默认同 @constant
                ["@constant.macro"]        = { fg = "#DD9046" },                   -- 默认同 @constant

                ---- 属性（Property） --------------------------------------------------------------
                ["@property"]              = { fg = "#34BFD0" },                   -- 默认 c.cyan  =#34BFD0

                ---- 枚举（Enum） ------------------------------------------------------------------
                ["@enum"]                  = { fg = "#EFBD5D" },                   -- 默认同 @type
                ["@enum.member"]           = { fg = "#93A4C3" },                   -- 默认同 @variable

                ---- 模块与命名空间（Module / Namespace） ------------------------------------------
                ["@module"]                = { fg = "#EFBD5D" },                   -- 默认 c.yellow=#EFBD5D
                ["@module.builtin"]        = { fg = "#DD9046" },                   -- 默认 c.orange=#DD9046
                ["@namespace"]             = { fg = "#DD9046" },                   -- 默认 c.orange=#DD9046

                --- 预处理器 / 宏（PreProc / Macro） -----------------------------------------------
                ["@preproc"]               = { fg = "#C75AE8" },                   -- 默认 c.purple=#C75AE8
                ["@macro"]                 = { fg = "#C75AE8" },                   -- 默认同 @preproc
                ["@define"]                = { fg = "#C75AE8" },                   -- 默认同 @preproc
                ["@include"]               = { fg = "#C75AE8" },                   -- 默认同 @preproc

                ---- HTML/XML 标签（Tag） ----------------------------------------------------------
                ["@tag"]                   = { fg = "#C75AE8" },                   -- 默认 c.purple=#C75AE8
                ["@tag.builtin"]           = { fg = "#C75AE8" },                   -- 默认同 @tag
                ["@tag.attribute"]         = { fg = "#EFBD5D" },                   -- 默认 c.yellow=#EFBD5D
                ["@tag.delimiter"]         = { fg = "#C75AE8" },                   -- 默认 c.purple=#C75AE8

                ---- 运算符（Operator） ------------------------------------------------------------
                ["@operator"]              = { fg = "#93A4C3" },                   -- 默认 c.fg    =#93A4C3

                ---- 标点符号（Punctuation） -------------------------------------------------------
                ["@punctuation.bracket"]   = { fg = "#6C7D9C" },                   -- 默认 c.light_grey=#6C7D9C
                ["@punctuation.delimiter"] = { fg = "#6C7D9C" },                   -- 默认 c.light_grey=#6C7D9C
                ["@punctuation.special"]   = { fg = "#F65866" },                   -- 默认 c.red   =#F65866

                ---- 标签 / 标注（Label） ----------------------------------------------------------
                ["@label"]                 = { fg = "#F65866" },                   -- 默认 c.red   =#F65866

                ---- 注解 / 装饰器（Attribute / Decorator） ----------------------------------------
                ["@attribute"]             = { fg = "#34BFD0" },                   -- 默认 c.cyan  =#34BFD0
                ["@attribute.builtin"]     = { fg = "#41A7FC" },                   -- 默认 c.blue  =#41A7FC

                ---- Markdown 样式 -----------------------------------------------------------------
                ["@markup.heading"]        = { fg = "#DD9046", fmt = "bold" },     -- 默认 c.orange bold
                ["@markup.heading.1"]      = { fg = "#F65866", fmt = "bold" },     -- 默认 c.red bold
                ["@markup.heading.2"]      = { fg = "#C75AE8", fmt = "bold" },     -- 默认 c.purple bold
                ["@markup.heading.3"]      = { fg = "#DD9046", fmt = "bold" },     -- 默认 c.orange bold
                ["@markup.heading.4"]      = { fg = "#F65866", fmt = "bold" },     -- 默认 c.red bold
                ["@markup.heading.5"]      = { fg = "#C75AE8", fmt = "bold" },     -- 默认 c.purple bold
                ["@markup.heading.6"]      = { fg = "#DD9046", fmt = "bold" },     -- 默认 c.orange bold
                ["@markup.strong"]         = { fg = "#93A4C3", fmt = "bold" },     -- 默认 c.fg bold
                ["@markup.italic"]         = { fg = "#93A4C3", fmt = "italic" },   -- 默认 c.fg italic
                ["@markup.strikethrough"]  = { fg = "#93A4C3", fmt = "strikethrough" },
                ["@markup.underline"]      = { fg = "#93A4C3", fmt = "underline" },
                ["@markup.link"]           = { fg = "#41A7FC" },                   -- 默认 c.blue  =#41A7FC
                ["@markup.link.label"]     = { fg = "#34BFD0" },                   -- 默认 c.cyan  =#34BFD0
                ["@markup.link.url"]       = { fg = "#34BFD0", fmt = "underline" },-- 默认 c.cyan 下划线
                ["@markup.list"]           = { fg = "#F65866" },                   -- 默认 c.red   =#F65866
                ["@markup.list.checked"]   = { fg = "#8BCD5B", fmt = "italic" },   -- 默认 c.green italic
                ["@markup.list.unchecked"] = { fg = "#F65866", fmt = "italic" },   -- 默认 c.red italic
                ["@markup.math"]           = { fg = "#93A4C3" },                   -- 默认 c.fg
                ["@markup.quote"]          = { fg = "#455574", fmt = "italic" },   -- 默认 c.grey italic
                ["@markup.raw"]            = { fg = "#8BCD5B" },                   -- 默认 c.green =#8BCD5B
                ["@markup.raw.block"]      = { fg = "#8BCD5B" },                   -- 默认同 @markup.raw

                ---- Diff 差异 ---------------------------------------------------------------------
                ["@diff.plus"]             = { fg = "#8BCD5B" },                   -- 默认 c.green =#8BCD5B
                ["@diff.minus"]            = { fg = "#F65866" },                   -- 默认 c.red   =#F65866
                ["@diff.delta"]            = { fg = "#41A7FC" },                   -- 默认 c.blue  =#41A7FC

                ---- LSP Semantic Tokens → 链接到 Treesitter 组 ------------------------------------
                ["@lsp.type.comment"]        = "@comment",
                ["@lsp.type.keyword"]        = "@keyword",
                ["@lsp.type.string"]         = "@string",
                ["@lsp.type.number"]         = "@number",
                ["@lsp.type.boolean"]        = "@boolean",
                ["@lsp.type.function"]       = "@function",
                ["@lsp.type.method"]         = "@method",
                ["@lsp.type.type"]           = "@type",
                ["@lsp.type.class"]          = "@type",
                ["@lsp.type.struct"]         = "@type",
                ["@lsp.type.enum"]           = "@type",
                ["@lsp.type.interface"]      = "@type",
                ["@lsp.type.typeParameter"]  = "@type",
                ["@lsp.type.variable"]       = "@variable",
                ["@lsp.type.parameter"]      = "@variable.parameter",
                ["@lsp.type.property"]       = "@property",
                ["@lsp.type.enumMember"]     = "@variable",
                ["@lsp.type.namespace"]      = "@namespace",
                ["@lsp.type.macro"]          = "@function.macro",
                ["@lsp.type.decorator"]      = "@attribute",
                ["@lsp.type.operator"]       = "@operator",
                ["@lsp.type.modifier"]       = "@keyword",
                ["@lsp.type.regexp"]         = "@string.regex",
        },
})
