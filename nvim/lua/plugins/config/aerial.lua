require('aerial').setup({
  -- 显示位置：'right' 或 'left'，默认右
  placement = 'right',
  -- 窗口宽度
  width = 40,
  -- 显示符号类型图标
  show_icons = true,
  -- 符号来源：优先使用 treesitter，其次 lsp
  backends = { 'treesitter', 'lsp', 'markdown', 'man' },
  -- 布局控制
  layout = {
    default_direction = 'prefer_right',
    max_width = { 40, 0.2 },   -- 最大 40 列或窗口宽度的 20%
    min_width = 30,
  },
  -- 显示哪些符号类型（默认显示所有，但可以按需过滤）
  filter_kind = {
    'Array', 'Boolean', 'Class', 'Constant', 'Constructor', 'Enum',
    'EnumMember', 'Event', 'Field', 'File', 'Function', 'Interface',
    'Key', 'Method', 'Module', 'Namespace', 'Null', 'Number', 'Object',
    'Operator', 'Package', 'Property', 'String', 'Struct', 'TypeParameter',
    'Variable',
  },
  -- 窗口内按键映射
  keymaps = {
    ['<CR>'] = 'actions.jump',      -- 回车跳转
    ['<C-v>'] = 'actions.jump_vsplit', -- 垂直分屏跳转
    ['<C-s>'] = 'actions.jump_split',   -- 水平分屏跳转
    ['p'] = 'actions.scroll',        -- 预览
    ['q'] = 'actions.close',         -- 关闭窗口
  },
})
