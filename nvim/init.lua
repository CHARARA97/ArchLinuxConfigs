vim.opt.termguicolors = true

local function bootstrap_pckr()
    local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
    if not (vim.uv or vim.loop).fs_stat(pckr_path) then
        vim.fn.system({
            'git',
            'clone',
            "--filter=blob:none",
            'https://github.com/lewis6991/pckr.nvim',
        pckr_path
        })
    end
    vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()
require('pckr').add{
  -- My plugins here
  -- 'foo1/bar1.nvim';
  -- 'foo2/bar2.nvim';
}

-- 加载核心配置
require('core.options')
require('core.keymaps')
require('core.autocmds')

-- 加载插件
require('plugins.init')
require('plugins.config.lualine')
require('plugins.config.neo-tree')
require('plugins.config.telescope')
require('plugins.config.colorizer')
require('plugins.config.colorpicker')
require('plugins.config.toggleterm')
require('plugins.config.code_runner')
require('plugins.config.flash')
require('plugins.config.aerial')

-- 加载主题
require('plugins.config.tokyonight')
vim.cmd("highlight ColorColumn guibg=#222233")

-- 为所有 .conf 文件自动设置文件类型为 dosini
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.conf",
  command = "set filetype=dosini"
})
