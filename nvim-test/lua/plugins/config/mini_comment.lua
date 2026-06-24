-- mini.comment 自定义逻辑
-- 目标语言中 gc/gcc：普通内容 → //---- content -------... (填到 colorcolumn)
--                         再按 gc/gcc → 恢复原内容
-- 空白行不处理（留给你自己的 <A-c>）
-- 非目标语言：mini.comment 默认 toggle

local target = {
    c = true, cpp = true, csharp = true, objc = true, objcpp = true,
    java = true, kotlin = true,
    javascript = true, typescript = true, javascriptreact = true, typescriptreact = true,
    rust = true, go = true, zig = true, swift = true,
    css = true, scss = true, less = true, sass = true,
}

--- 注释前缀： "// %s" → "//"
local function prefix()
    local cs = vim.bo.commentstring or ""
    if cs == "" then cs = vim.filetype.get_option(vim.bo.filetype, "commentstring") or "// %s" end
    if cs == "" then cs = "// %s" end
    local p = cs:match("^(.-)%%s")
    return p and vim.trim(p) or "//"
end

--- 目标列宽
local function tcol()
    local cc = vim.opt.colorcolumn:get()
    if type(cc) == "table" and #cc > 0 then return tonumber(cc[1]) or 80
    elseif type(cc) == "string" and cc ~= "" then return tonumber(vim.split(cc, ",")[1]) or 80
    end
    return 80
end

--- 完整左前缀： "//---- "
local function full_left(p)
    return p .. "---- "
end

--- 是否匹配装饰注释格式： //---- content ----------...
local function is_decorated(line, p)
    return line:find("^%s*" .. vim.pesc(p) .. "%-%-%-%- .+ %-+%s*$") ~= nil
end

--- 给单行套上装饰注释
local function comment_line(lnum, line, p, col)
    local indent = line:match("^(%s*)") or ""
    local content = line:sub(#indent + 1)
    local left = full_left(p)
    local prefix_len = vim.api.nvim_strwidth(indent .. left .. content .. " ")
    local pad_len = col - prefix_len
    local pad = ""
    if pad_len > 0 then
        pad = string.rep("-", pad_len)
    end
    local result = indent .. left .. content .. " " .. pad
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { result })
end

--- 给单行解码装饰注释
local function uncomment_line(lnum, line, p)
    -- 匹配缩进 + //---- content ---...
    local indent, content = line:match(
        "^(%s*)" .. vim.pesc(p) .. "%-%-%-%- (.+) %-+%s*$")
    if indent and content then
        vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false,
            { indent .. content })
    end
end

-- =============== mini.comment 配置 ===============

local ok, mini_comment = pcall(require, "mini.comment")
if not ok then
    vim.notify("mini.comment 加载失败: " .. tostring(mini_comment), vim.log.levels.ERROR)
    return
end

local setup_ok, setup_err = pcall(mini_comment.setup, {
    hooks = {
        pre = function(info)
            local ft = vim.bo.filetype
            if not target[ft] then return end

            local p = prefix()
            local col = tcol()
            local lines = vim.api.nvim_buf_get_lines(
                0, info.line_start - 1, info.line_end, false)

            -- 决定每行是注释还是取消注释（toggle 模式逐行判断）
            for i, line in ipairs(lines) do
                local lnum = info.line_start + i - 1
                if line:match("^%s*$") then
                    -- 空白行：跳过
                elseif is_decorated(line, p) then
                    -- 装饰格式 → 恢复原内容（注释→取消）
                    uncomment_line(lnum, line, p)
                elseif info.action == "uncomment" then
                    -- 取消模式但非装饰行：跳过
                else
                    -- comment 或 toggle 模式，非装饰行 → 套装饰注释
                    comment_line(lnum, line, p, col)
                end
            end

            return false
        end,
    },
})

if not setup_ok then
    vim.notify("mini.comment setup 失败: " .. tostring(setup_err), vim.log.levels.ERROR)
    return
end

-- 显式映射 gcc，覆盖 Neovim 0.12 内置的 gcc（否则内置优先，不走 hook）
vim.keymap.set('n', 'gcc', function()
    mini_comment.toggle_lines(vim.fn.line('.'), vim.fn.line('.'))
end, { desc = 'Comment line (decorated)' })

-- =============== 可视模式 gc：块注释 ===============

--- 首行匹配块注释开头，返回缩进（匹配时）或 nil
local function block_open_indent(line)
    return line:match("^(%s*)/%*%*%-+%s*$")
end

--- 尾行匹配块注释结尾（同缩进）
local function block_close_ok(line, indent)
    return line:match("^" .. vim.pesc(indent) .. "%-+%*%/%s*$") ~= nil
end

--- 中间行是块注释内容
local function is_block_mid(line)
    return line:match("^%s*%*%s") ~= nil
end

--- 提取块注释中间行的内容
local function block_mid_content(line)
    return line:match("^%s*%*%s(.+)$") or line:gsub("^%s*%*%s?", "", 1)
end

--- 整个选区是否已是块注释格式
local function is_block_range(sl, el)
    local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)
    if not lines or #lines < 3 then return false end
    local indent = block_open_indent(lines[1])
    if not indent then return false end
    if not block_close_ok(lines[#lines], indent) then return false end
    for i = 2, #lines - 1 do
        if not is_block_mid(lines[i]) then return false end
    end
    return true
end

--- 套块注释（通过 toggle_lines 让 mini.comment 管理 undo/redo）
local function apply_block(sl, el, col)
    local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)
    if not lines or #lines == 0 then return end
    local indent = lines[1]:match("^(%s*)") or ""
    local bopen = "/**"
    local bclose = "*/"
    local result = {}
    result[1] = indent .. bopen .. string.rep("-", col - #indent - #bopen)
    for _, line in ipairs(lines) do
        result[#result + 1] = indent .. " * " .. (line:match("^%s*(.+)$") or "")
    end
    local dl = col - #indent - #bclose
    result[#result + 1] = indent .. string.rep("-", dl > 0 and dl or 0) .. bclose
    vim.api.nvim_buf_set_lines(0, sl - 1, el, false, result)
end

--- 解块注释
local function remove_block(sl, el)
    local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)
    if not lines or #lines < 3 then return end
    local indent = block_open_indent(lines[1])
    if not indent then return end
    local result = {}
    for i = 2, #lines - 1 do
        result[#result + 1] = indent .. block_mid_content(lines[i])
    end
    vim.api.nvim_buf_set_lines(0, sl - 1, el, false, result)
end

-- 必须先删除 mini.comment 和内置的 x gc 映射，否则 expr=true 的映射可能抢走优先
pcall(vim.keymap.del, 'x', 'gc')
vim.keymap.set('x', 'gc', function()
    local sl = vim.fn.line("v")
    local el = vim.fn.line(".")
    if el < sl then sl, el = el, sl end

    if not target[vim.bo.filetype] then
        mini_comment.toggle_lines(sl, el)
        return
    end

    if is_block_range(sl, el) then
        remove_block(sl, el)
    else
        apply_block(sl, el, tcol())
    end
end, { desc = 'Block comment (decorated)' })
