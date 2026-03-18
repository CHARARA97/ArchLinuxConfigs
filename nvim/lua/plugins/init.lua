local pckr = require('pckr')

pckr.add('lewis6991/pckr.nvim')                     -- pckr
pckr.add('folke/tokyonight.nvim')                   -- TokyoNight主题（Night）
pckr.add('nvim-lualine/lualine.nvim')               -- 状态栏指示
pckr.add('nvim-tree/nvim-web-devicons')             -- 配合lualine的图标
pckr.add('nvim-neo-tree/neo-tree.nvim')             -- NeoTree
pckr.add('nvim-lua/plenary.nvim')                   -- NeoTree的工具库
pckr.add('MunifTanjim/nui.nvim')                    -- NeoTree的UI框架
pckr.add('christoomey/vim-tmux-navigator')          -- 窗口间转换
pckr.add('norcalli/nvim-colorizer.lua')             -- 颜色代码预览
pckr.add('ziontee113/color-picker.nvim')            -- ColorPicker
pckr.add('folke/flash.nvim')                        -- 光标跳转
pckr.add('stevearc/aerial.nvim')                    -- 代码大纲
pckr.add('keaising/im-select.nvim')
pckr.add('williamboman/mason.nvim')
pckr.add('williamboman/mason-lspconfig.nvim')
pckr.add('neovim/nvim-lspconfig')
pckr.add('hrsh7th/nvim-cmp')                 -- 补全引擎
pckr.add('hrsh7th/cmp-nvim-lsp')             -- LSP 补全源
pckr.add('hrsh7th/cmp-buffer')                -- 缓冲区单词补全
pckr.add('hrsh7th/cmp-path')                  -- 文件路径补全
pckr.add('hrsh7th/cmp-cmdline')               -- 命令行补全
pckr.add('L3MON4D3/LuaSnip')                  -- 代码片段引擎
pckr.add('saadparwaiz1/cmp_luasnip')          -- 片段补全源

-- （可选）LSP 增强 UI
pckr.add('folke/lsp-colors.nvim')             -- 为 LSP 诊断提供颜色
pckr.add('ray-x/lsp_signature.nvim')          -- 函数签名提示
-- Toggletrem
pckr.add({
    'akinsho/toggleterm.nvim',
    tag = 'v2.*',
    config = function()
    end
})
-- CodeRunner
pckr.add({
    'CRAG666/code_runner.nvim',
    requires = { 'akinsho/toggleterm.nvim' },
    config = function() require('plugins.config.code_runner') end
})
-- Telescope
pckr.add({
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
})
-- Treesitter
pckr.add({
    'nvim-treesitter/nvim-treesitter',
    opt = true,
    run = function() require(
        'nvim-treesitter.install').update({
            with_sync = true}) end
})
