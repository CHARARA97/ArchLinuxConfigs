require('lualine').setup({
  options = {
    theme = 'tokyonight',                                     -- 主题自动匹配你的配色
    component_separators = { left = '|', right = '|'},  -- 组件分隔符
    section_separators = { left = '', right = ''},      -- 区块分隔符
  },
  sections = {
    lualine_a = {'mode'},                               -- 左侧A区：显示当前模式
    lualine_b = {'branch', 'diff', 'diagnostics'},      -- 左侧B区：Git分支、更改、LSP诊断
    lualine_c = {'filename'},                           -- 左侧C区：文件名
    lualine_x = {'encoding', 'fileformat', 'filetype'}, -- 右侧X区：编码、格式、类型
    lualine_y = {'progress'},                           -- 右侧Y区：当前行/列进度
    lualine_z = {'location'}                            -- 右侧Z区：光标位置
  }
})
