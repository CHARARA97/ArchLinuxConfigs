local flash = require('flash')

-- 初始化 flash 插件
flash.setup({
  -- 搜索时是否高亮所有匹配项
  highlight = { backdrop = true },
  -- 在搜索中是否智能处理大小写
  modes = {
    search = { enabled = false }, -- 禁用内置的搜索模式，使用下面自定义的
    char = { enabled = true },    -- 启用字符跳转模式
  },
})
