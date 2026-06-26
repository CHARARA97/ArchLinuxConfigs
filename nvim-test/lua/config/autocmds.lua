vim.api.nvim_create_user_command( "Syu", function()
                require( "vim.pack" ).update()
        end, { desc = "Sync plugins using vim.pack" }
)
vim.api.nvim_create_autocmd( "VimEnter",
        {
                callback = function()
                        vim.cmd( "silent! TSUpdate" )
                end,
        }
)

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
        ---- 取 colorcolumn 第二条提示线，默认 100 -------------------------------------------------
        local cc = vim.opt.colorcolumn:get()
        local col = 100
        if type( cc ) == "table" and #cc > 1 then
                col = tonumber( cc[2] ) or col
        elseif type( cc ) == "string" and cc ~= "" then
                local parts = vim.split(cc, ",")
                col = tonumber( parts[2] or parts[1] ) or col
        end

        ---- 从 commentstring 提取注释前缀： "-- %s" → "--" ----------------------------------------
        local cs = vim.bo.commentstring or ""
        if cs == "" then cs = vim.filetype.get_option(vim.bo.filetype, "commentstring") or "-- %s" end
        if cs == "" then cs = "-- %s" end
        local p = cs:match( "^(.-)%%s" )
        p = p and vim.trim( p ) or "--"

        local current = vim.fn.getline( "." )

        ---- 场景 1：空白行 → 生成 ---- 分隔线，进入插入模式 ---------------------------------------
        if current:match( "^%s*$" ) then
                local prefix = p .. "---- "
                local cur = vim.fn.line( "." )
                vim.api.nvim_buf_set_lines( 0, cur, cur, false, { prefix } )
                vim.api.nvim_win_set_cursor( 0, { cur + 1, #prefix } )
                vim.cmd( "startinsert!" )
                return
        end

        ---- 场景 2：非空白行 → 行尾填充横杠到目标列 -----------------------------------------------
        local dw = vim.api.nvim_strwidth( current )
        if dw < col then
                local new_line = current .. " " .. string.rep( "-", col - dw - 1 )
                local cur = vim.fn.line( "." )
                vim.api.nvim_buf_set_lines( 0, cur - 1, cur, false, { new_line } )
        end
end
