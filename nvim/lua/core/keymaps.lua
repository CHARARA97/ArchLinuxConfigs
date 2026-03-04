local keymap = vim.keymap.set
-- 空格键为Leader键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- --------快捷键--------
keymap('n', '<leader>w', ':w<CR>')                      -- 空格+ w 保存文件
keymap('n', '<leader>q', ':q<CR>')                      -- 空格+ q 退出
keymap('n', '<leader>nh', ':nohlsearch<CR>')            -- 空格+ h 取消搜索高亮
keymap('n', '<leader>e', ':Neotree toggle<CR>')         -- 空格+ e 打开Neotree
keymap('n', '<leader>sv', '<C-w>v')                     -- 空格+ sv 新增水平窗口
keymap('n', '<leader>sh', '<C-w>s')                     -- 空格+ sh 新增垂直窗口

-- 跳转窗口
keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>')       -- ctrl + hjkl 跳转窗口
keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>')
keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>')         
keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>') 

keymap('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>')  -- 跳转到上一个面板

-- F5一键编译运行
local config_root = vim.fn.stdpath('config')
local compile_run_path = config_root .. '/lua/core/compile_run.lua'
local compile_run = dofile(compile_run_path)

--------Telescope--------
-- 查找文件
keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = '[F]ind [F]iles' })
-- 全局搜索文本
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = '[F]ind by [G]rep' })
-- 查找缓冲区
keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = '[F]ind [B]uffers' })
-- 查找帮助标签
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = '[F]ind [H]elp' })
