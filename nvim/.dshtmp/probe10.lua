-- Emulate exactly what TSHighlighter does and dump the winning highlight per column.
-- group name = '@' .. capture .. '.' .. lang   (see treesitter/highlighter.lua:43)
if os.getenv("TS_RTP") then
    vim.opt.rtp:prepend(os.getenv("TS_RTP"))
end
local path = vim.fn.fnamemodify(arg[1], ":p")
local lines = vim.fn.readfile(arg[1])
vim.cmd("edit " .. vim.fn.fnameescape(path))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)

local TS_PRIO = vim.hl.priorities.treesitter

local function winner_at(row, col)
    local caps = vim.treesitter.get_captures_at_pos(buf, row, col)
    -- captures come in for_each_tree order; each new lang run = next subtree (= _subpriority)
    local sub, prev, n = {}, nil, 0
    for i, c in ipairs(caps) do
        if c.lang ~= prev then
            n = n + 1
            prev = c.lang
        end
        sub[i] = n
    end
    local best, bk
    for i, c in ipairs(caps) do
        if c.capture:sub(1, 1) ~= "_" then -- highlighter skips @_helper captures
            local prio = tonumber(c.metadata and c.metadata.priority) or TS_PRIO
            local k = { prio, sub[i], i }
            if
                not bk
                or k[1] > bk[1]
                or (k[1] == bk[1] and k[2] > bk[2])
                or (k[1] == bk[1] and k[2] == bk[2] and k[3] >= bk[3])
            then
                best, bk = c, k
            end
        end
    end
    if not best then
        return nil
    end
    local group = "@" .. best.capture .. "." .. (best.lang or "")
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    return {
        group = group,
        capture = best.capture,
        lang = best.lang,
        priority = bk[1],
        fg = hl.fg and string.format("#%06x", hl.fg) or nil,
        bold = hl.bold or false,
        italic = hl.italic or false,
    }
end

local out = { file = arg[1], bg = nil, fg = nil, lines = {} }
local norm = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
out.bg = norm.bg and string.format("#%06x", norm.bg) or "#000000"
out.fg = norm.fg and string.format("#%06x", norm.fg) or "#ffffff"

local seen = {}
for row = 1, #lines do
    local line = lines[row]
    local cells = {}
    for col = 1, #line do
        local w = winner_at(row - 1, col - 1)
        cells[#cells + 1] = { char = line:sub(col, col), w = w }
        if w then
            local k = w.group .. "|" .. tostring(w.fg) .. "|" .. tostring(w.bold) .. "|" .. tostring(w.italic)
            seen[k] = (seen[k] or 0) + 1
        end
    end
    out.lines[#out.lines + 1] = cells
end

local f = assert(io.open(".dshtmp/hl_dump.json", "w"))
f:write(vim.json.encode(out))
f:close()

print("bg=" .. out.bg .. " fg=" .. out.fg)
print(string.format("%-42s %-9s %-9s %s", "group", "fg", "style", "cols"))
local keys = vim.tbl_keys(seen)
table.sort(keys)
for _, k in ipairs(keys) do
    local g, fg, b, i = k:match("^(.-)|(.-)|(.-)|(.*)$")
    local style = (b == "true" and "bold " or "") .. (i == "true" and "italic" or "")
    print(string.format("%-42s %-9s %-9s %d", g, fg, style, seen[k]))
end
vim.cmd("qa!")
