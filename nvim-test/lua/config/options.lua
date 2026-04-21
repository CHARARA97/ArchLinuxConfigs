local opt = vim.opt
local cmd = vim.cmd

opt.number = true                 -- 显示行号
opt.relativenumber = true         -- 显示相对行号（方便跳转）
opt.signcolumn = "yes"            -- 显示标记栏

opt.tabstop = 8                   -- Tab键显示为8个空格宽度
opt.shiftwidth = 8                -- 自动缩进时为8个空格
opt.expandtab = true              -- 将Tab转换为空格
opt.autoindent = true             -- 继承基础缩进
opt.shiftround = true             -- 缩进自动对齐
cmd("filetype plugin indent on")  -- 自动决定缩进方式

opt.wrap = false                  -- 禁用软换行
opt.colorcolumn = "80,100"        -- 列宽提示线

opt.ignorecase = true             -- 搜索时忽略大小写
opt.smartcase = true              -- 如果搜索包含大写，则开启大小写敏感

-- opt.mouse = 'a'                   -- 启用鼠标支持
opt.clipboard = "unnamedplus"     -- 与系统共享剪切板

opt.cursorline = true             -- 高亮当前行
opt.cursorcolumn = true           -- 高亮当前列

opt.scrolloff = 8                 -- 光标上下最少保留八行

opt.undofile = true               -- 保存撤销历史

opt.splitright = true             -- 分窗时分到右侧
opt.splitbelow = true             -- 分窗时分到下面

-- opt.encoding = "UTF-8"
-- opt.fileencoding = "UTF-8"
-- opt.fileencodings = "ucs-bom,utf-8,gbk,gb2312,cp936,latin1"

-- 禁用不需要的语言 Provider，以清理 :checkhealth 警告
vim.g.loaded_node_provider = 0      -- 禁用 Node.js Provider
vim.g.loaded_python3_provider = 0   -- 禁用 Python3 Provider
vim.g.loaded_perl_provider = 0      -- 禁用 Perl Provider
vim.g.loaded_ruby_provider = 0      -- 禁用 Ruby Provider
