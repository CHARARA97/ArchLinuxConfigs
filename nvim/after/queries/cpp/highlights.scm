; extends
; ---------------------------------------------------------------------------------------------------
; 修正 cpp 查询里「大写开头 = 构造函数」的启发式
; ---------------------------------------------------------------------------------------------------
; nvim-treesitter 的 cpp 查询会把「大写开头的函数调用」也标成 @constructor，
; 于是函数调用和函数定义同色（tokyonight 下都会变紫）。
; 这里在 after 查询里把调用处重新捕获为 @function.call / @function.method.call：
; after 查询最后加载，同一位置、同优先级下后设置的高亮覆盖 @constructor，
; 结果是「定义 = @constructor（紫），调用 = @function.call（白）」。
; ---------------------------------------------------------------------------------------------------

(call_expression
  function: (identifier) @function.call)

(call_expression
  function: (qualified_identifier
    name: (identifier) @function.call))

(call_expression
  function: (field_expression
    field: (field_identifier) @function.method.call))
