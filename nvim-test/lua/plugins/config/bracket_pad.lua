---- 括号内部自动加空格 --------------------------------------------------------
---- 用法：( aaa ) 光标在内容上 → ( aaa )  ·  自动识别最内层 ---------------------

local function find_bracket_pair()
    local cur = vim.api.nvim_win_get_cursor( 0 )
    local cline = cur[1]
    local ccol = cur[2] + 1   -- nvim_win_get_cursor col 是 0-indexed，sub 需要 1-indexed
    local all = vim.api.nvim_buf_get_lines( 0, 0, -1, false )
    local n = #all
    -- 从光标向后扫描，找到最近的未闭合 (
    local open_line, open_col, depth = nil, nil, 0
    for line = cline, 1, -1 do
        local txt = all[line] or ""
        local start = ( line == cline ) and ccol or #txt
        local pos = start
        while pos >= 1 do
            local ch = txt:sub( pos, pos )
            if ch == ")" then
                depth = depth + 1
            elseif ch == "(" then
                if depth == 0 then
                    open_line, open_col = line, pos
                    break
                end
                depth = depth - 1
            end
            pos = pos - 1
        end
        if open_line then break end
    end
    if not open_line then
        print( "[pad] backward scan failed" )
        return nil
    end
    print( string.format( "[pad] backward: open=(%d,%d)", open_line, open_col ) )
    -- 从找到的 ( 向前扫描匹配的 )
    local close_line, close_col
    depth = 0
    for line = open_line, n do
        local txt = all[line] or ""
        local start = ( line == open_line ) and (open_col + 1) or 1
        for pos = start, #txt do
            local ch = txt:sub( pos, pos )
            if ch == "(" then
                depth = depth + 1
            elseif ch == ")" then
                if depth == 0 then
                    close_line, close_col = line, pos
                    break
                end
                depth = depth - 1
            end
        end
        if close_line then break end
    end
    if not close_line then return nil end
    -- 验证光标在括号内
    if cline < open_line or cline > close_line
        or ( cline == open_line and ccol <= open_col )
        or ( cline == close_line and ccol >= close_col ) then
        return nil
    end
    return { { open_line, open_col }, { close_line, close_col } }
end

function _G.pad_brackets()
    local pair = find_bracket_pair()
    if pair then
        print( string.format( "[pad] found: (%d,%d)-(%d,%d)",
            pair[1][1], pair[1][2], pair[2][1], pair[2][2] ) )
    else
        local c = vim.api.nvim_win_get_cursor(0)
        print( string.format( "[pad] not found, cursor=%d,%d", c[1], c[2] ) )
        vim.notify( "Not inside parentheses", vim.log.levels.WARN )
        return
    end
    local open, close = pair[1], pair[2]
    if open[1] == close[1] then
        local line = vim.fn.getline( open[1] )
        vim.fn.setline( open[1],
            line:sub( 1, open[2] ) .. " " .. line:sub( open[2] + 1, close[2] - 1 ) .. " " .. line:sub( close[2] ) )
    else
        local ol = vim.fn.getline( open[1] )
        local cl = vim.fn.getline( close[1] )
        vim.fn.setline( open[1], ol:sub( 1, open[2] ) .. " " .. ol:sub( open[2] + 1 ) )
        vim.fn.setline( close[1], cl:sub( 1, close[2] - 1 ) .. " " .. cl:sub( close[2] ) )
    end
end
