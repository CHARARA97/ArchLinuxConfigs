; extends
;
; 背景：doxygen grammar 只把少数标签建模成「标签 + 标识符」(@param / @namespace / @exception ...)，
; 它自带的查询也只对 @param 抓参数名：
;     ((tag (tag_name) @_p (identifier) @variable.parameter) (#any-of? @_p "@param" "\\param"))
; 而 @tparam / @retval 没有建模，参数名落在 (description) 节点里（实测树：
;     tag -> tag_name "@tparam", description "T type desc"），整个 description 是一个 token，
; 没法直接抓到里面的 T。所以这里抓 description，再用自定义 directive #first-word!
; 把高亮范围裁到第一个词。directive 在 lua/plugins/config/treesitter.lua 里注册，两者要一起用。
;
; 想再加同类标签（同样"标签 + 名字 + 描述"但没建模的），照着复制一段改 #any-of? 即可，
; 例如 "@def"、"@defgroup-name" 之类。

; @tparam T 描述
((tag
  (tag_name) @_tp
  (description) @variable.parameter)
  (#any-of? @_tp "@tparam" "\\tparam")
  (#first-word! @variable.parameter))

; @retval 0 描述
((tag
  (tag_name) @_tp
  (description) @variable.parameter)
  (#any-of? @_tp "@retval" "\\retval")
  (#first-word! @variable.parameter))
