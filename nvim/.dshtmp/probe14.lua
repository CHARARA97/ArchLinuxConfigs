-- register a directive that shrinks a captured node to its first word
vim.treesitter.query.add_directive("first-word!", function(match, _, source, pred, metadata)
    local id = pred[2]
    local nodes = match[id]
    local node = nodes and nodes[1]
    if not node then
        return
    end
    local text = vim.treesitter.get_node_text(node, source)
    local word = text:match("^%S+")
    if not word then
        return
    end
    local sr, sc = node:range()
    metadata[id] = metadata[id] or {}
    metadata[id].range = { sr, sc, sr, sc + #word }
end, { force = true })

if os.getenv("TS_AFTER") then
    vim.opt.rtp:append(os.getenv("TS_AFTER"))
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

for row = 1, #lines do
    local line = lines[row]
    if line:match("%S") then
        local runs, cur = {}, nil
        for col = 1, #line do
            local r = resolve_at(row - 1, col - 1)
            local key = string.format("%s|%s", r.from, r.fg)
            if cur and cur.key == key then
                cur.text = cur.text .. line:sub(col, col)
            else
                cur = { key = key, text = line:sub(col, col), r = r }
                runs[#runs + 1] = cur
            end
        end
        local parts = {}
        for _, run in ipairs(runs) do
            parts[#parts + 1] = string.format("[%s]%s(%s)", run.text, run.r.from or "nil", run.r.fg or "-")
        end
        print(string.format("L%-3d %s", row, table.concat(parts, " ")))
    end
end
vim.cmd("qa!")
