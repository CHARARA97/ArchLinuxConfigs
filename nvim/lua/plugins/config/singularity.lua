---- Singularity — 语法高亮配色 --------------------------------------------------------------------
---- 结构对齐 plugins.config.tokyonight：调色板 C + 局部样式 + S()/U() 辅助 + 按类别分块的 H 表 ----
---- 规则 -------------------------------------------------------------------------------------------
----   主体：所有语法组统一白色（保留原有的粗体 / 斜体 / 下划线）-----------------------------------
----   例外 1：注释 / 字符串 / 宏 / 数字 保留彩色 ---------------------------------------------------
----   例外 2：函数定义与 tokyonight 一致（蓝 #7AA2F7），函数调用仍为白色 -------------------------
---- 编辑 -------------------------------------------------------------------------------------------
----   换一类颜色      -> 改上面 C 里的色值 ---------------------------------------------------------
----   换某一个组      -> 改 H 里对应那一行 ---------------------------------------------------------
----   加一个新类型    -> 往 H 里加一行，例如 ["@xxx"] = S( C.white ) --------------------------------
---- 切换：:Sing（在 themes.lua 注册），启动默认就是它 ----------------------------------------------

local M = {}

---- 底座：背景 / UI / 插件 / 终端色 / diff 沿用 tokyonight-night -----------------------------------
M.base = { plugin = "tokyonight.nvim", style = "night", colors_name = "tokyonight-night" }

---- 调色板 ---------------------------------------------------------------------------------------
local C = {
        white            = "#C0CAF5",

        ---- 注释 -------------------------------------------------------------------------------
        comment          = "#6A9955",
        comment_error    = "#F7768E",
        comment_warn     = "#E0AF68",
        comment_todo     = "#7AA2F7",
        comment_note     = "#1ABC9C",
        comment_info     = "#0DB9D7",
        comment_hint     = "#1ABC9C",

        ---- 字符串 / 字符 -----------------------------------------------------------------------
        string           = "#8BCD5B",
        string_doc       = "#E0AF68",
        string_regex     = "#B4F9F8",
        string_escape    = "#BB9AF7",
        string_special   = "#2AC3DE",

        ---- 数字 -------------------------------------------------------------------------------
        number           = "#FF9E64",

        ---- 宏 / 预处理 ------------------------------------------------------------------------
        macro            = "#7DCFFF",

        ---- 运算符
        operator         = "#EFBD5D",

        ---- 关键字（与 tokyonight 一致：return 紫，if/else/continue 浅紫）----------------------------
        keyword          = "#9D7CD8",
        keyword_fn       = "#BB9AF7",

        ---- 函数定义
        function_def     = "#7AA2F7",

        ---- 构造函数 / 成员函数名（与 tokyonight 一致）-------------------------------------------
        constructor      = "#BB9AF7",

        ---- doxygen 注释内标签 ------------------------------------------------------------------
        doxygen_function = "#7AA2F7",
        doxygen_variable = "#C0CAF5",
        doxygen_param    = "#EFBD5D",
        doxygen_tag      = "#BB9AF7",

        ---- vimdoc 标题分隔线要靠背景色盖住，不能刷白 ------------------------------------------
        vimdoc_hidden    = "#1A1B26",
}

---- 局部样式 -------------------------------------------------------------------------------------
local bold   = { bold = true }
local italic = { italic = true }
local bi     = { bold = true, italic = true }
local under  = { underline = true }

---- 辅助：给颜色叠样式 ---------------------------------------------------------------------------
local function S( color, style ) return vim.tbl_extend( "force", { fg = color }, style or {} ) end
local function U( color ) return { fg = color, underline = true } end

---- 高亮表 ---------------------------------------------------------------------------------------
---- 键 = Treesitter / LSP 高亮组名，值 = S(颜色, 样式)；全部 191 个类型都在这里 --------------------
local H = {

        ---- 注释(Comment) -----------------------------------------------------------------------
        ["@comment"]               = S( C.comment, italic ),
        ["@comment.documentation"] = S( C.comment, italic ),
        ["@comment.error"]         = S( C.comment_error, italic ),
        ["@comment.hint"]          = S( C.comment_hint, italic ),
        ["@comment.info"]          = S( C.comment_info, italic ),
        ["@comment.note"]          = S( C.comment_note, italic ),
        ["@comment.todo"]          = S( C.comment_todo, bi ),
        ["@comment.warning"]       = S( C.comment_warn, italic ),

        ---- Doxygen(C/C++ 文档注释) — 配合 after/queries/doxygen/highlights.scm ------------------
        ["@keyword.doxygen"]               = S( C.comment, italic ),
        ["@keyword.modifier.doxygen"]      = S( C.comment, italic ),
        ["@variable.parameter.doxygen"]    = S( C.doxygen_param, italic ),
        ["@variable.doxygen"]              = S( C.doxygen_variable, italic ),
        ["@function.doxygen"]              = S( C.doxygen_function, italic ),
        ["@label.doxygen"]                 = S( C.string_special, italic ),
        ["@tag.doxygen"]                   = S( C.doxygen_tag, italic ),
        ["@markup.italic.doxygen"]         = S( C.string_doc, italic ),
        ["@punctuation.delimiter.doxygen"] = S( C.comment, italic ),
        ["@punctuation.bracket.doxygen"]   = S( C.comment, italic ),
        ["@operator.doxygen"]              = S( C.comment, italic ),

        ---- 关键字(Keyword) — 全白 --------------------------------------------------------------
        ["@keyword"]                    = S( C.white, bold ),
        ["@keyword.conditional"]        = S( C.keyword_fn ),
        ["@keyword.conditional.ternary"] = S( C.keyword_fn ),
        ["@keyword.coroutine"]          = S( C.white, bold ),
        ["@keyword.debug"]              = S( C.white ),
        ["@keyword.exception"]          = S( C.white ),
        ["@keyword.function"]           = S( C.white ),
        ["@keyword.import"]             = S( C.white, italic ),
        ["@keyword.modifier"]           = S( C.white, bold ),
        ["@keyword.operator"]           = S( C.operator ),
        ["@keyword.repeat"]             = S( C.keyword_fn ),
        ["@keyword.return"]             = S( C.keyword, bold ),
        ["@keyword.storage"]            = S( C.white ),
        ["@keyword.type"]               = S( C.white ),

        ---- 预处理器 / 宏 — 保留彩色 ------------------------------------------------------------
        ["@keyword.directive"]        = S( C.macro ),
        ["@keyword.directive.define"] = S( C.macro ),
        ["@preproc"]                  = S( C.macro ),
        ["@macro"]                    = S( C.macro ),
        ["@define"]                   = S( C.macro ),
        ["@include"]                  = S( C.macro ),
        ["@function.macro"]           = S( C.macro ),
        ["@constant.macro"]           = S( C.macro ),

        ---- 字符串(String) — 保留彩色 -----------------------------------------------------------
        ["@string"]                = S( C.string ),
        ["@string.documentation"]  = S( C.string_doc ),
        ["@string.escape"]         = S( C.string_escape ),
        ["@string.regex"]          = S( C.string_regex ),
        ["@string.regexp"]         = S( C.string_regex ),
        ["@string.special"]        = S( C.string_special ),
        ["@string.special.path"]   = S( C.string ),
        ["@string.special.symbol"] = S( C.string_special ),
        ["@string.special.url"]    = U( C.macro ),

        ---- 字符 / 数字 / 布尔 -----------------------------------------------------------------
        ["@character"]           = S( C.string ),
        ["@character.printf"]    = S( C.string_special ),
        ["@character.special"]   = S( C.string_special ),
        ["@number"]              = S( C.number ),
        ["@number.float"]        = S( C.number ),
        ["@boolean"]             = S( C.white ),

        ---- 函数 / 方法 — 定义用 tokyonight 蓝，调用白色 ----------------------------------------
        ["@function"]             = S( C.function_def, bold ),
        ["@function.method"]      = S( C.function_def, bi ),
        ["@method"]               = S( C.function_def, bold ),
        ["@function.call"]        = S( C.white ),
        ["@function.method.call"] = S( C.white ),
        ["@method.call"]          = S( C.white ),
        ["@function.builtin"]     = S( C.white ),
        ["@constructor"]          = S( C.constructor ),
        ["@constructor.tsx"]      = S( C.constructor ),

        ---- 类型(Type) — 全白 ------------------------------------------------------------------
        ["@type"]             = S( C.white ),
        ["@type.builtin"]     = S( C.white ),
        ["@type.definition"]  = S( C.white ),
        ["@type.qualifier"]   = S( C.white ),

        ---- 变量(Variable) — 全白 --------------------------------------------------------------
        ["@variable"]                   = S( C.white ),
        ["@variable.builtin"]           = S( C.white ),
        ["@variable.member"]            = S( C.white ),
        ["@variable.parameter"]         = S( C.white ),
        ["@variable.parameter.builtin"] = S( C.white ),

        ---- 常量 / 属性 / 枚举 / 模块 / 命名空间 — 全白 ----------------------------------------
        ["@constant"]          = S( C.white ),
        ["@constant.builtin"]  = S( C.white ),
        ["@property"]          = S( C.white ),
        ["@enum"]              = S( C.white ),
        ["@enum.member"]       = S( C.white ),
        ["@module"]            = S( C.white ),
        ["@module.builtin"]    = S( C.white ),
        ["@namespace"]         = S( C.white ),
        ["@namespace.builtin"] = S( C.white ),

        ---- HTML/XML 标签 — 全白 ---------------------------------------------------------------
        ["@tag"]               = S( C.white ),
        ["@tag.attribute"]     = S( C.white ),
        ["@tag.builtin"]       = S( C.white ),
        ["@tag.delimiter"]     = S( C.white ),
        ["@tag.delimiter.tsx"] = S( C.white ),
        ["@tag.javascript"]    = S( C.white ),
        ["@tag.tsx"]           = S( C.white ),

        ---- 运算符 / 标点 — 全白 ---------------------------------------------------------------
        ["@operator"]                   = S( C.operator ),
        ["@punctuation"]                = S( C.white ),
        ["@punctuation.bracket"]        = S( C.white ),
        ["@punctuation.delimiter"]      = S( C.white ),
        ["@punctuation.special"]        = S( C.white ),
        ["@punctuation.special.markdown"] = S( C.white ),

        ---- 标注 / 装饰器 / 注解 — 全白 ---------------------------------------------------------
        ["@label"]            = S( C.white ),
        ["@attribute"]        = S( C.white ),
        ["@attribute.builtin"] = S( C.white ),
        ["@decorator"]        = S( C.white ),
        ["@annotation"]       = S( C.white ),

        ---- Markdown / 标记 — 全白；vimdoc 隐藏分隔线保持背景色 ---------------------------------
        ["@markup"]                     = S( C.white ),
        ["@markup.strong"]              = S( C.white, bold ),
        ["@markup.italic"]              = S( C.white, italic ),
        ["@markup.emphasis"]            = S( C.white, italic ),
        ["@markup.strikethrough"]       = { fg = C.white, strikethrough = true },
        ["@markup.underline"]           = S( C.white, under ),
        ["@markup.heading"]             = S( C.white, bold ),
        ["@markup.heading.1"]           = S( C.white, bold ),
        ["@markup.heading.2"]           = S( C.white, bold ),
        ["@markup.heading.3"]           = S( C.white, bold ),
        ["@markup.heading.4"]           = S( C.white, bold ),
        ["@markup.heading.5"]           = S( C.white, bold ),
        ["@markup.heading.6"]           = S( C.white, bold ),
        ["@markup.heading.1.markdown"]  = S( C.white, bold ),
        ["@markup.heading.2.markdown"]  = S( C.white, bold ),
        ["@markup.heading.3.markdown"]  = S( C.white, bold ),
        ["@markup.heading.4.markdown"]  = S( C.white, bold ),
        ["@markup.heading.5.markdown"]  = S( C.white, bold ),
        ["@markup.heading.6.markdown"]  = S( C.white, bold ),
        ["@markup.heading.7.markdown"]  = S( C.white, bold ),
        ["@markup.heading.8.markdown"]  = S( C.white, bold ),
        ["@markup.heading.1.delimiter.vimdoc"] = S( C.vimdoc_hidden ),
        ["@markup.heading.2.delimiter.vimdoc"] = S( C.vimdoc_hidden, under ),
        ["@markup.quote"]               = S( C.white, italic ),
        ["@markup.math"]                = S( C.white ),
        ["@markup.raw"]                 = S( C.white ),
        ["@markup.raw.block"]           = S( C.white ),
        ["@markup.raw.markdown_inline"] = S( C.white ),
        ["@markup.link"]                = S( C.white ),
        ["@markup.link.label"]          = S( C.white ),
        ["@markup.link.label.symbol"]   = S( C.white ),
        ["@markup.link.url"]            = S( C.white, under ),
        ["@markup.list"]                = S( C.white ),
        ["@markup.list.checked"]        = S( C.white ),
        ["@markup.list.unchecked"]      = S( C.white ),
        ["@markup.list.markdown"]       = S( C.white, bold ),
        ["@markup.environment"]         = S( C.white ),
        ["@markup.environment.name"]    = S( C.white ),

        ---- 差异(Diff) — 全白 --------------------------------------------------------------
        ["@diff.plus"]  = S( C.white ),
        ["@diff.minus"] = S( C.white ),
        ["@diff.delta"] = S( C.white ),

        ---- LSP 语义令牌 — 只有 comment / string / number / macro 保留彩色 -----------------------
        ---- 注意：函数/方法令牌清空(={})，否则它优先级更高，会盖掉 Treesitter 并连调用一起染色 ----
        ["@lsp.type.comment"]  = S( C.comment, italic ),
        ["@lsp.type.string"]   = S( C.string ),
        ["@lsp.type.number"]   = S( C.number ),
        ["@lsp.type.macro"]    = S( C.macro ),
        ["@lsp.typemod.string.injected"]      = S( C.string ),
        ["@lsp.typemod.macro.defaultLibrary"] = S( C.string_special ),

        ["@lsp.type.boolean"]                  = S( C.white ),
        ["@lsp.type.builtinType"]              = S( C.white ),
        ["@lsp.type.class"]                    = S( C.white ),
        ["@lsp.type.decorator"]                = S( C.white ),
        ["@lsp.type.deriveHelper"]             = S( C.white ),
        ["@lsp.type.enum"]                     = S( C.white ),
        ["@lsp.type.enumMember"]               = S( C.white ),
        ["@lsp.type.escapeSequence"]           = S( C.white ),
        ["@lsp.type.event"]                    = S( C.white ),
        ["@lsp.type.formatSpecifier"]          = S( C.white ),
        ["@lsp.type.function"]                 = {},   -- 清空：交给 Treesitter 的 @function / @function.call
        ["@lsp.type.generic"]                  = S( C.white ),
        ["@lsp.type.interface"]                = S( C.white ),
        ["@lsp.type.keyword"]                  = S( C.white, bold ),
        ["@lsp.type.lifetime"]                 = S( C.white ),
        ["@lsp.type.method"]                   = {},   -- 清空：同上（LSP 令牌无法区分定义与调用）
        ["@lsp.type.modifier"]                 = S( C.white, bold ),
        ["@lsp.type.namespace"]                = S( C.white ),
        ["@lsp.type.namespace.python"]         = S( C.white ),
        ["@lsp.type.operator"]                 = S( C.operator),
        ["@lsp.type.parameter"]                = S( C.white ),
        ["@lsp.type.property"]                 = S( C.white ),
        ["@lsp.type.regexp"]                   = S( C.white ),
        ["@lsp.type.selfKeyword"]              = S( C.white ),
        ["@lsp.type.selfTypeKeyword"]          = S( C.white ),
        ["@lsp.type.struct"]                   = S( C.white ),
        ["@lsp.type.type"]                     = S( C.white ),
        ["@lsp.type.typeAlias"]                = S( C.white ),
        ["@lsp.type.typeParameter"]            = S( C.white ),
        ["@lsp.type.variable"]                 = S( C.white ),
        ["@lsp.typemod.class.defaultLibrary"]  = S( C.white ),
        ["@lsp.typemod.enum.defaultLibrary"]   = S( C.white ),
        ["@lsp.typemod.enumMember.defaultLibrary"] = S( C.white ),
        ["@lsp.typemod.function.defaultLibrary"]   = S( C.white ),
        ["@lsp.typemod.keyword.async"]         = S( C.white ),
        ["@lsp.typemod.keyword.injected"]      = S( C.white ),
        ["@lsp.typemod.method.defaultLibrary"] = S( C.white ),
        ["@lsp.typemod.operator.injected"]     = S( C.white ),
        ["@lsp.typemod.struct.defaultLibrary"] = S( C.white ),
        ["@lsp.typemod.type.defaultLibrary"]   = S( C.white ),
        ["@lsp.typemod.typeAlias.defaultLibrary"] = S( C.white ),
        ["@lsp.typemod.variable.callable"]     = S( C.white ),
        ["@lsp.typemod.variable.defaultLibrary"] = S( C.white ),
        ["@lsp.typemod.variable.injected"]     = S( C.white ),
        ["@lsp.typemod.variable.static"]       = S( C.white ),

        ---- 经典语法组（没有 Treesitter parser 时 vim 自带 syntax 使用）------------------------
        ["Comment"]        = S( C.comment, italic ),
        ["SpecialComment"] = S( C.comment, italic ),
        ["String"]         = S( C.string ),
        ["Character"]      = S( C.string ),
        ["Number"]         = S( C.number ),
        ["Float"]          = S( C.number ),
        ["Boolean"]        = S( C.white ),
        ["Constant"]       = S( C.white ),
        ["Identifier"]     = S( C.white ),
        ["Function"]       = S( C.function_def, bold ),
        ["Statement"]      = S( C.white ),
        ["Conditional"]    = S( C.keyword_fn ),
        ["Repeat"]         = S( C.keyword_fn ),
        ["Label"]          = S( C.white ),
        ["Operator"]       = S( C.operator ),
        ["Keyword"]        = S( C.white ),
        ["Exception"]      = S( C.white ),
        ["PreProc"]        = S( C.macro ),
        ["Include"]        = S( C.macro ),
        ["Define"]         = S( C.macro ),
        ["Macro"]          = S( C.macro ),
        ["PreCondit"]      = S( C.macro ),
        ["Type"]           = S( C.white ),
        ["StorageClass"]   = S( C.white ),
        ["Structure"]      = S( C.white ),
        ["Typedef"]        = S( C.white ),
        ["Special"]        = S( C.string_special ),
        ["SpecialChar"]    = S( C.string_special ),
        ["Tag"]            = S( C.white ),
        ["Delimiter"]      = S( C.white ),
        ["Debug"]          = S( C.white ),
        ["Title"]          = S( C.white, bold ),
}

---- 应用：铺底座 → 按表设置 → 标记主题名 ---------------------------------------------------------
function M.apply()
        ---- 已经站在 tokyonight / singularity 上时不重载底座，避免多余的 hi clear -----------------
        if vim.g.colors_name ~= M.base.colors_name and vim.g.colors_name ~= "singularity" then
                require( "tokyonight" ).load( { style = M.base.style } )
        end

        for name, spec in pairs( H ) do
                vim.api.nvim_set_hl( 0, name, spec )
        end

        vim.g.colors_name = "singularity"
        vim.o.termguicolors = true
end

return M
