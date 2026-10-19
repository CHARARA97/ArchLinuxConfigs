; extends
; @tparam 在 doxygen grammar 里没有被建模成 "tag + identifier"，
; 参数名 T 落在 (description) 节点里，所以这里抓 description 再用
; 自定义 directive #first-word! 把范围裁到第一个词。
((tag
  (tag_name) @_tp
  (description) @variable.parameter)
  (#any-of? @_tp "@tparam" "\\tparam")
  (#first-word! @variable.parameter))

((tag
  (tag_name) @_tp
  (description) @variable.parameter)
  (#any-of? @_tp "@retval" "\\retval")
  (#first-word! @variable.parameter))
