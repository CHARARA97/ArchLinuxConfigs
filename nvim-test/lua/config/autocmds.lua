vim.api.nvim_create_user_command( "Syu", function()
        require( "vim.pack" ).update()
        end, {  desc = "Sync plugins using vim.pack"  } )
        vim.api.nvim_create_autocmd( "VimEnter", { 
                callback = function()
                        vim.cmd( "silent! TSUpdate" )
        end,
 } )

function _G.toggle_qf()
        local qf_exists = false
        for _, win in ipairs( vim.api.nvim_list_wins() ) do
                local buf = vim.api.nvim_win_get_buf( win )
                if vim.bo[buf].filetype == 'qf' then
                        qf_exists = true
                        vim.api.nvim_win_close( win, true )
                        break
                end
        end
        if not qf_exists then
                vim.cmd( 'copen' )
        end
end

function _G.comment_line()
        local cc = vim.opt.colorcolumn:get()
        local col = 80
        if type( cc ) == "table" and #cc > 0 then
                col = tonumber( cc[1] ) or col
        elseif type( cc ) == "string" and cc ~= "" then
                col = tonumber( vim.split( cc, "," )[1] ) or col
        end

        local current = vim.fn.getline( "." )

        ---- 场景 1：空白行 → 生成 //---- 前缀，进入插入模式 -------------------
        if current:match( "^%s*$" ) then
                local prefix = "//---- "
                local cur = vim.fn.line( "." )
                vim.api.nvim_buf_set_lines( 0, cur, cur, false, { prefix } )
                vim.api.nvim_win_set_cursor( 0, { cur + 1, #prefix } )
                vim.cmd( "startinsert!" )
                return
        end

        ---- 场景 2：非空白行 → 行尾加空格 + 横杠填充到 col --------------------
        do
                local dw = vim.api.nvim_strwidth( current )  -- 显示宽度（中文占 2）
                if dw < col then
                        local new_line = current .. " " .. string.rep( "-", col - dw - 1 )
                        local cur = vim.fn.line( "." )
                        vim.api.nvim_buf_set_lines( 0, cur - 1, cur, false, { new_line } )
                end
        end
end
