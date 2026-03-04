local pckr = require('pckr')

pckr.add('lewis6991/pckr.nvim')                     -- pckr
pckr.add('folke/tokyonight.nvim')                   -- TokyoNight主题（Night）
pckr.add('nvim-lualine/lualine.nvim')               -- 状态栏指示
pckr.add('nvim-tree/nvim-web-devicons')             -- 配合lualine的图标
pckr.add('nvim-neo-tree/neo-tree.nvim')             -- NeoTree
pckr.add('nvim-lua/plenary.nvim')                   -- NeoTree的工具库
pckr.add('MunifTanjim/nui.nvim')                    -- NeoTree的UI框架
pckr.add('christoomey/vim-tmux-navigator')          -- 窗口间转换
pckr.add({
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/[lenary.nvim' }
})
pckr.add({
    'nvim-treesitter/nvim-treesitter',
    opt = true,
    path = '~/.local/share/nvim/site/pack/pckr/opt/nvim-treesitter',
    run = function() require(
        'nvim-treesitter.install').update({
            with_sync = true}) end
})
