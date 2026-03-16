local keymap = vim.keymap.set

--空格键为Leader键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-----------快捷键--------
keymap('n', '<leader>w', ':w<CR>')                      -- 空格 + w 保存文件
keymap('n', '<leader>q', ':q<CR>')                      -- 空格 + q 退出
keymap('n', '<leader>nh', ':nohlsearch<CR>')            -- 空格 + h 取消搜索高亮
keymap('n', '<leader>e', ':Neotree toggle<CR>')         -- 空格 + e 打开Neotree
keymap('n', '<leader>sv', '<C-w>v')                     -- 空格 + sv 新增水平窗口
keymap('n', '<leader>sh', '<C-w>s')                     -- 空格 + sh 新增垂直窗口

-- 行首/行尾
keymap('n', '<leader>h', '0', { desc = 'Go to start of line' })
keymap('n', '<leader>l', '$', { desc = 'Go to end of line' })

-- 文件头/文件尾
keymap('n', '<leader>k', 'gg', { desc = 'Go to top of file' })
keymap('n', '<leader>j', 'G', { desc = 'Go to bottom of file' })

                                                        -- 空格 + c 打开ColorPicker
keymap('n', '<leader>pc', '<cmd>PickColor<CR>',{ noremap = true, silent = true })

                                                        -- CodeRunner
keymap('n', '<leader>rr', ':RunCode<CR>', { noremap = true, silent = false })
keymap('n', '<leader>rf', ':RunFile<CR>', { noremap = true, silent = false })
keymap('n', '<leader>rft', ':RunFile tab<CR>', { noremap = true, silent = false })
keymap('n', '<leader>rp', ':RunProject<CR>', { noremap = true, silent = false })
keymap('n', '<leader>rc', ':RunClose<CR>', { noremap = true, silent = false })
keymap('n', '<leader>crf', ':CRFiletype<CR>', { noremap = true, silent = false })
keymap('n', '<leader>crp', ':CRProjects<CR>', { noremap = true, silent = false })

-- 普通模式下，快速移动当前行
-- Alt + j 向下移动
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true, desc = 'Move line down' })
-- Alt + k 向上移动
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true, desc = 'Move line up' })

-- 可视模式下，移动选中行
-- Alt + j 向下移动
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Move selected lines down' })
-- Alt + k 向上移动
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Move selected lines up' })

-- 跳转窗口
keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>')       -- ctrl + hjkl 跳转窗口
keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>')
keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>')         
keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>') 

--keymap('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>')  -- 跳转到上一个面板

--------Flash---------
-- 1. 最常用的“闪跳”：按 <leaders>s 触发，然后输入任意字符搜索
keymap({'n', 'x', 'o'}, '<leader>s', function()
  require('flash').jump()
end, { desc = 'Flash: Jump' })

-- 2. 远程操作模式：先按操作符 (d, y, c)，再按此快捷键触发 flash，然后选择目标
keymap({'n', 'x', 'o'}, '<leader>S', function()
  require('flash').treesitter()
end, { desc = 'Flash: Treesitter Select' })

-- 3. 更经典的远程操作模式：类似 leap 的两字符风格，但支持更多操作
keymap({'n', 'x', 'o'}, 's', function()
  require('flash').treesitter()
end, { desc = 'Flash: Remote Operation' })

--------Aerial------------
-- 大纲开关
keymap('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Aerial (code outline)' })

--------Telescope--------
-- 查找文件
keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = '[F]ind [F]iles' })
-- 全局搜索文本
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = '[F]ind by [G]rep' })
-- 查找缓冲区
keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = '[F]ind [B]uffers' })
-- 查找帮助标签
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = '[F]ind [H]elp' })
