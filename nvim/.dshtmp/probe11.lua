-- Resolve the rendered highlight of every column the same way TSHighlighter does:
--   group name = '@' .. capture .. '.' .. lang   (treesitter/highlighter.lua:43)
-- captures are applied in (priority, subtree order, capture order) and attributes are merged.
if os.getenv("TS_RTP") then
    vim.opt.rtp:prepend(os.getenv("TS_RTP"))
end
local lines = vim.fn.readfile(arg[1])
vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(arg[1], ":p")))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)

local TS_PRIO = vim.hl.priorities.treesitter

local function resolve_at(row, col)
    local caps = vim.treesitter.get_captures_at_pos(buf, row, col)
    local sub, prev, n, ordered = {}, nil, 0, {}
    for i, c in ipairs(caps) do
        if c.lang ~= prev then
            n = n + 1
            prev = c.lang
        end
        if c.capture:sub(1, 1) ~= "_" then
            ordered[#ordered + 1] = {
                name = c.capture,
                lang = c.lang or "",
                prio = tonumber(c.metadata and c.metadata.priority) or TS_PRIO,
                sub = n,
                ord = i,
            }
        end
    end
    table.sort(ordered, function(a, b)
        if a.prio ~= b.prio then
            return a.prio < b.prio
        end
        if a.sub ~= b.sub then
            return a.sub < b.sub
        end
        return a.ord < b.ord
    end)
    local res = { fg = nil, bold = nil, italic = nil, from = nil, all = {} }
    for _, c in ipairs(ordered) do
        local group = "@" .. c.name .. "." .. c.lang
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        res.all[#res.all + 1] = group
        if hl.fg and res.fg == nil then
            -- later (higher priority / later subtree) wins, so overwrite
        end
        if hl.fg then
            res.fg = string.format("#%06x", hl.fg)
            res.from = group
        end
        if hl.bold ~= nil then
            res.bold = hl.bold
        end
        if hl.italic ~= nil then
            res.italic = hl.italic
        end
    end
    return res
end

local norm = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
local out = {
    file = arg[1],
    bg = norm.bg and string.format("#%06x", norm.bg) or "#000000",
    fg = norm.fg and string.format("#%06x", norm.fg) or "#ffffff",
    lines = {},
    groups = {},
}
local seen = {}
for row = 1, #lines do
    local line = lines[row]
    local cells = {}
    for col = 1, #line do
        local r = resolve_at(row - 1, col - 1)
        cells[#cells + 1] = { char = line:sub(col, col), fg = r.fg, bold = r.bold, italic = r.italic, from = r.from }
        local k = string.format("%-32s fg=%-8s bold=%-5s italic=%-5s", tostring(r.from), tostring(r.fg), tostring(r.bold), tostring(r.italic))
        seen[k] = (seen[k] or 0) + 1
    end
    out.lines[#out.lines + 1] = cells
end
local f = assert(io.open(".dshtmp/hl_dump.json", "w"))
f:write(vim.json.encode(out))
f:close()

print("bg=" .. out.bg .. " fg=" .. out.fg)
local keys = vim.tbl_keys(seen)
table.sort(keys)
for _, k in ipairs(keys) do
    print(string.format("%-80s x%d", k, seen[k]))
end
vim.cmd("qa!")
