-- Faithful re-implementation of TSHighlighter's on_line capture resolution,
-- including metadata range overrides (used by custom directives).
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

local Range = require("vim.treesitter._range")
local lines = vim.fn.readfile(arg[1])
vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(arg[1], ":p")))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)
local h = assert(vim.treesitter.highlighter.active[buf], "no highlighter")

local function inside(range, row, col)
    local sr, sc, er, ec = Range.unpack4(range)
    local after_start = row > sr or (row == sr and col >= sc)
    local before_end = row < er or (row == er and col < ec)
    return after_start and before_end
end

local function resolve_at(row, col)
    local ordered, subtree = {}, 0
    h.tree:for_each_tree(function(tstree, tree)
        if not tstree then
            return
        end
        subtree = subtree + 1
        local root = tstree:root()
        local sr, _, er = root:range()
        if sr > row or er < row then
            return
        end
        local q = h:get_query(tree:lang()):query()
        if not q then
            return
        end
        local ord = 0
        for id, node, metadata, _ in q:iter_captures(root, buf, row, row + 1) do
            ord = ord + 1
            local capture = q.captures[id]
            if capture and capture:sub(1, 1) ~= "_" then
                local range = vim.treesitter.get_range(node, buf, metadata and metadata[id])
                if range and inside(range, row, col) then
                    ordered[#ordered + 1] = {
                        name = capture,
                        lang = tree:lang(),
                        prio = tonumber(metadata and (metadata.priority or (metadata[id] and metadata[id].priority)))
                            or vim.hl.priorities.treesitter,
                        sub = subtree,
                        ord = ord,
                    }
                end
            end
        end
    end)
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
        local parts, cur = {}, nil
        for col = 1, #line do
            local r = resolve_at(row - 1, col - 1)
            local key = string.format("%s|%s", r.from, r.fg)
            if cur and cur.key == key then
                cur.text = cur.text .. line:sub(col, col)
            else
                cur = { key = key, text = line:sub(col, col), r = r }
                parts[#parts + 1] = cur
            end
        end
        local out = {}
        for _, run in ipairs(parts) do
            out[#out + 1] = string.format("[%s]%s(%s)", run.text, run.r.from or "nil", run.r.fg or "-")
        end
        print(string.format("L%-3d %s", row, table.concat(out, " ")))
    end
end
vim.cmd("qa!")
