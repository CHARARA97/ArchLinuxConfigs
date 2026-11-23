---- 主题总管模块 ----------------------------------------------------------------------------------
---- 负责：加载所有主题配置 + 切换命令 + 设置默认主题 ----------------------------------------------

---- 先加载包(vim.pack.add 放在 opt/ 中，需要 packadd 才能 require) --------------------------------
vim.cmd( "packadd tokyonight.nvim" )
vim.cmd( "packadd onedark.nvim" )

---- 加载各主题的 setup(注册配色参数，不切换) ------------------------------------------------------
require( "plugins.config.tokyonight" )
require( "plugins.config.onedark" )
require( "plugins.config.singularity" )

---- 光标颜色 --------------------------------------------------------------------------------------
---- 注意：切换主题时 colorscheme / hi clear 会把 Cursor 一起清掉(光标变白)，所以每次 ColorScheme
---- 之后再套一遍粉色 ---------------------------------------------------------
local function set_cursor()
        vim.api.nvim_set_hl( 0, "Cursor", { fg = "#FF0088", bg = "#FF0088" } )
        vim.api.nvim_command( 'highlight Cursor guibg=#FF0088 guifg=#000000' )
end

set_cursor()
vim.g.neovide_cursor_unfocused_outline_width = 0.1
vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

vim.api.nvim_create_autocmd( "ColorScheme", {
        group    = vim.api.nvim_create_augroup( "UserCursorColor", { clear = true } ),
        callback = set_cursor,
} )

---- 默认主题：Singularity（底座 tokyonight-night）-------------------------------------------------
---- 没有 colors/ 目录，不经过 :colorscheme，这里手动补一次 ColorScheme 事件 -------------------------
---- 让光标颜色 / lualine 等按主题刷新（pattern 用主题名，和 :colorscheme 时一致）--------------------
local function use_singularity()
        require( "plugins.config.singularity" ).apply()
        vim.api.nvim_exec_autocmds( "ColorScheme", { pattern = "singularity" } )
end

use_singularity()

---- 注册切换命令 ----------------------------------------------------------------------------------
vim.api.nvim_create_user_command( 'Toku', function()
        vim.cmd( "colorscheme tokyonight-night" )
        vim.notify( '切换到 TokyoNight night', vim.log.levels.INFO )
end, {}
)

vim.api.nvim_create_user_command( 'One', function()
        vim.cmd( "packadd onedark.nvim" )
        require( 'onedark' ).setup( { style = 'deep' } )
        vim.cmd( "colorscheme onedark" )
        vim.notify( '切换到 Onedark deep', vim.log.levels.INFO )
end, {}
)

vim.api.nvim_create_user_command( 'Sing', function()
        use_singularity()
        vim.notify( '切换到 Singularity（语法白色 / 注释 字符串 宏 数字 保留彩色）', vim.log.levels.INFO )
end, {}
)

vim.api.nvim_create_user_command( 'Theme', function()
        vim.notify( '当前主题: ' .. ( vim.g.colors_name or "unknown" ), vim.log.levels.INFO )
end, {}
)
