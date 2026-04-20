local km = vim.keymap.set

---------------------- Leader键 ----------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

km('n', '<leader>w', ':w<CR>',          { desc = 'Write' })
km('n', '<leader>q', ':q<CR>',          { desc = 'Quit' })
km('n', '<leader>h', '0',               { desc = 'Go to start of line' })
km('n', '<leader>l', '$',               { desc = 'Go to end of line' })
km('n', '<leader>k', 'gg',              { desc = 'Go to top of file' })
km('n', '<leader>j', 'G',               { desc = 'Go to bottom of file' })
km('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
km('n', '-', '<cmd>Oil<CR>',            { desc = 'Open parent directory with Oil' })
km('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>')
km('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>')
km('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>')         
km('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>') 

