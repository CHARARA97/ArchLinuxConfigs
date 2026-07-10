---- TokyoNight night ------------------------------------------------------------------------------

require( 'tokyonight' ).setup(
        {
                style           = "night",
                transparent     = false,
                terminal_colors = true,
                cache           = false,
                styles =
                {
                        comments  = { italic = true, bold = true },
                        keywords  = { italic = true },
                        functions = { italic = true, bold = true },
                },
                on_highlights = function( hl, c )
                        ---- 调色板 ----------------------------------------------------------------
                        local C = {
                                comment           = "#6A9955",
                                comment_error     = "#F7768E",
                                comment_warn      = "#E0AF68",
                                comment_todo      = "#7AA2F7",
                                comment_note      = "#1ABC9C",
                                comment_info      = "#0DB9D7",
                                comment_hint      = "#1ABC9C",

                                keyword           = "#9D7CD8",
                                keyword_fn        = "#BB9AF7",
                                keyword_import    = "#7DCFFF",
                                keyword_storage   = "#2AC3DE",
                                keyword_directive = "#7DCFFF",
                                keyword_modifier  = "#27A1B9",

                                string            = "#8BCD5B",
                                string_doc        = "#E0AF68",
                                string_regex      = "#B4F9F8",
                                string_escape     = "#BB9AF7",
                                string_special    = "#2AC3DE",

                                number            = "#FF9E64",
                                boolean           = "#FF9E64",

                                function_def      = "#7AA2F7",
                                function_call     = "#7AA2F7",
                                function_builtin  = "#2AC3DE",
                                function_macro    = "#7DCFFF",
                                constructor       = "#BB9AF7",

                                type              = "#2AC3DE",
                                type_builtin      = "#27A1B9",

                                variable          = "#C0CAF5",
                                variable_builtin  = "#F65866",
                                variable_member   = "#73DACA",
                                variable_param    = "#EFBD5D",

                                constant          = "#FF9E64",

                                property          = "#73DACA",

                                operator          = "#89DDFF",
                                punctuation_bracket="#A9B1D6",
                                punctuation_delim = "#FFFFFF",

                                tag               = "#BB9AF7",
                                tag_attr          = "#73DACA",
                                tag_delim         = "#2AC3DE",

                                label             = "#7AA2F7",
                                attribute         = "#7DCFFF",
                                decorator         = "#7DCFFF",

                                diff_add          = "#449DAB",
                                diff_del          = "#914C54",
                                diff_change       = "#6183BB",
                        }

                        local bold   = { bold = true }
                        local italic = { italic = true }
                        local bi = { bold = true, italic = true }

                        local function S( color, style ) return vim.tbl_extend( "force", { fg = color }, style or {} ) end
                        local function U( color ) return { fg = color, underline = true } end

                        ---- 注释(Comment) — Treesitter --------------------------------------------
                        hl["@comment"]                = S( C.comment, italic )
                        hl["@comment.documentation"]  = S( C.comment, italic )
                        hl["@comment.error"]          = S( C.comment_error, italic )
                        hl["@comment.warning"]        = S( C.comment_warn,  italic )
                        hl["@comment.todo"]           = S( C.comment_todo,  bi )
                        hl["@comment.note"]           = S( C.comment_note,  italic )
                        hl["@comment.info"]           = S( C.comment_info,  italic )
                        hl["@comment.hint"]           = S( C.comment_hint,  italic )

                        ---- 关键字(Keyword) — Treesitter ------------------------------------------
                        hl["@keyword"]                = S( C.keyword, bold )
                        hl["@keyword.function"]       = S( C.keyword_fn )
                        hl["@keyword.return"]         = S( C.keyword, bold )
                        hl["@keyword.conditional"]    = S( C.keyword_fn )
                        hl["@keyword.repeat"]         = S( C.keyword_fn )
                        hl["@keyword.exception"]      = S( C.keyword_fn )
                        hl["@keyword.import"]         = S( C.keyword_import, italic )
                        hl["@keyword.storage"]        = S( C.keyword_storage )
                        hl["@keyword.directive"]      = S( C.keyword_directive )
                        hl["@keyword.operator"]       = S( C.operator )
                        hl["@keyword.coroutine"]      = S( C.keyword, bold )
                        hl["@keyword.modifier"]       = S( C.keyword_modifier, bold )
                        hl["@keyword.type"]           = S( C.keyword_import )

                        ---- 字符串(String) — Treesitter -------------------------------------------
                        hl["@string"]                 = S( C.string )
                        hl["@string.documentation"]   = S( C.string_doc )
                        hl["@string.regex"]           = S( C.string_regex )
                        hl["@string.escape"]          = S( C.string_escape )
                        hl["@string.special"]         = S( C.string_special )
                        hl["@string.special.symbol"]  = S( C.string_special )
                        hl["@string.special.url"]     = U( C.keyword_import )

                        ---- 字符 / 数字 / 布尔 — Treesitter ---------------------------------------
                        hl["@character"]              = S( C.string )
                        hl["@character.special"]      = S( C.string_special )
                        hl["@number"]                 = S( C.number )
                        hl["@number.float"]           = S( C.number )
                        hl["@boolean"]                = S( C.boolean )

                        ---- 函数 / 方法 — Treesitter ----------------------------------------------
                        hl["@function"]               = S( C.function_def, bold )
                        hl["@function.call"]          = S( C.function_call )
                        hl["@function.builtin"]       = S( C.function_builtin )
                        hl["@function.macro"]         = S( C.function_macro )
                        hl["@method"]                 = S( C.function_def, bold )
                        hl["@method.call"]            = S( C.function_call )
                        hl["@constructor"]            = S( C.constructor )

                        ---- 类型 — Treesitter -----------------------------------------------------
                        hl["@type"]                   = S( C.type )
                        hl["@type.builtin"]           = S( C.type_builtin )
                        hl["@type.definition"]        = S( C.type )
                        hl["@type.qualifier"]         = S( C.keyword )

                        ---- 变量 — Treesitter -----------------------------------------------------
                        hl["@variable"]               = S( C.variable )
                        hl["@variable.builtin"]       = S( C.variable_builtin )
                        hl["@variable.member"]        = S( C.variable_member )
                        hl["@variable.parameter"]     = S( C.variable_param )
                        hl["@variable.parameter.builtin"] = S( "#DAB484" )

                        ---- 常量 / 属性 / 枚举 / 模块 — Treesitter --------------------------------
                        hl["@constant"]               = S( C.constant )
                        hl["@constant.builtin"]       = S( C.function_builtin )
                        hl["@constant.macro"]         = S( C.function_macro )
                        hl["@property"]               = S( C.property )
                        hl["@enum"]                   = S( C.type )
                        hl["@enum.member"]            = S( C.keyword_fn )
                        hl["@namespace"]              = S( C.keyword_import )
                        hl["@namespace.builtin"]      = S( C.variable_builtin )
                        hl["@module"]                 = S( C.keyword_import )
                        hl["@module.builtin"]         = S( C.function_builtin )

                        ---- 预处理器 / 宏 — Treesitter --------------------------------------------
                        hl["@preproc"]                = S( C.keyword_import )
                        hl["@macro"]                  = S( C.keyword_import )
                        hl["@define"]                 = S( C.keyword_import )
                        hl["@include"]                = S( C.keyword_import )

                        ---- HTML/XML 标签 — Treesitter --------------------------------------------
                        hl["@tag"]                    = S( C.tag )
                        hl["@tag.attribute"]          = S( C.tag_attr )
                        hl["@tag.delimiter"]          = S( C.tag_delim )

                        ---- 运算符 / 标点 — Treesitter --------------------------------------------
                        hl["@operator"]               = S( C.operator )
                        hl["@punctuation.delimiter"]  = S( C.punctuation_delim )
                        hl["@punctuation.bracket"]    = S( C.punctuation_bracket )
                        hl["@punctuation.special"]    = S( C.punctuation_delim )
                        hl["@label"]                  = S( C.label )
                        hl["@attribute"]              = S( C.attribute )
                        hl["@decorator"]              = S( C.decorator )

                        ---- Diff — Treesitter -----------------------------------------------------
                        hl["@diff.plus"]              = S( C.diff_add )
                        hl["@diff.minus"]             = S( C.diff_del )
                        hl["@diff.delta"]             = S( C.diff_change )

                        ---- LSP Semantic Tokens → 链接到 Treesitter 组 ----------------------------
                        hl["@lsp.type.comment"]        = "@comment"
                        hl["@lsp.type.keyword"]        = "@keyword"
                        hl["@lsp.type.string"]         = "@string"
                        hl["@lsp.type.number"]         = "@number"
                        hl["@lsp.type.boolean"]        = "@boolean"
                        hl["@lsp.type.function"]       = "@function"
                        hl["@lsp.type.method"]         = "@method"
                        hl["@lsp.type.type"]           = "@type"
                        hl["@lsp.type.class"]          = "@type"
                        hl["@lsp.type.struct"]         = "@type"
                        hl["@lsp.type.enum"]           = "@type"
                        hl["@lsp.type.interface"]      = "@type"
                        hl["@lsp.type.typeParameter"]  = "@type"
                        hl["@lsp.type.variable"]       = "@variable"
                        hl["@lsp.type.parameter"]      = "@variable.parameter"
                        hl["@lsp.type.property"]       = "@property"
                        hl["@lsp.type.enumMember"]     = "@variable"
                        hl["@lsp.type.namespace"]      = "@namespace"
                        hl["@lsp.type.macro"]          = "@function.macro"
                        hl["@lsp.type.decorator"]      = "@attribute"
                        hl["@lsp.type.operator"]       = "@operator"
                        hl["@lsp.type.modifier"]       = "@keyword"
                        hl["@lsp.type.regexp"]         = "@string.regex"

                        ---- 当前行号 --------------------------------------------------------------
                        hl.CursorLineNr = { fg = "#FF9E64", bold = true }
                end,
        }
)
