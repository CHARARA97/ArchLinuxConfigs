-- Print, for every line, the runs of text with their *resolved* highlight group.
-- Same resolution as TSHighlighter: group = '@' .. capture .. '.' .. lang,
-- applied in (priority, subtree, order) order with attribute merging.
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
    local res = { fg = nil, bold = nil, italic = nil, from = nil }
    for _, c in ipairs(ordered) do
        local group = "@" .. c.name .. "." .. c.lang
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
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

local function esc(s)
    return (s:gsub("%s", function(c)
        return c == " " and " " or (c == "\t" and "\\t" or "")
    end))
end

local seen = {}
for row = 1, #lines do
    local line = lines[row]
    if line:match("%S") then
        local runs, cur = {}, nil
        for col = 1, #line do
            local r = resolve_at(row - 1, col - 1)
            local key = string.format("%s|%s|%s|%s", r.from, r.fg, r.bold, r.italic)
            if cur and cur.key == key then
                cur.text = cur.text .. line:sub(col, col)
            else
                cur = { key = key, text = line:sub(col, col), r = r }
                runs[#runs + 1] = cur
            end
            seen[key] = (seen[key] or 0) + 1
        end
        local parts = {}
        for _, run in ipairs(runs) do
            local style = (run.r.bold and "b" or "") .. (run.r.italic and "i" or "")
            parts[#parts + 1] = string.format("[%s]%s", esc(run.text), run.r.from or "nil")
        end
        print(string.format("L%-3d %s", row, table.concat(parts, " ")))
    end
end

print("\n---- groups seen ----")
local keys = vim.tbl_keys(seen)
table.sort(keys)
for _, k in ipairs(keys) do
    print(string.format("  %-70s x%d", k, seen[k]))
end
vim.cmd("qa!")
