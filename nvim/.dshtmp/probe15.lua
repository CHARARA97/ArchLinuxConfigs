-- Ground truth: attach a real UI (linegrid) so the treesitter decoration provider
-- actually runs, then read the screen attributes via screenattr()/screenstring().
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

local ok, err = pcall(vim.api.nvim_ui_attach, 200, 60, {
    ext_linegrid = true,
    rgb = true,
    ext_hlstate = true,
    override = true,
})
print("ui_attach ok=" .. tostring(ok) .. " err=" .. tostring(err))

local lines = vim.fn.readfile(arg[1])
vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(arg[1], ":p")))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)
vim.cmd("redraw")
pcall(vim.api.nvim__redraw, { buf = buf, flush = true, valid = true })
vim.cmd("redraw")

local function attr_at(row, col)
    -- screen coords are 1-based; buffer line numbers are 1-based too
    return vim.fn.screenattr(row, col + 1)
end

for row = 1, math.min(#lines, 12) do
    local line = lines[row]
    local parts = {}
    local last = nil
    for col = 1, #line do
        local a = attr_at(row, col - 1)
        if a ~= last then
            parts[#parts + 1] = string.format("|%d>", a)
            last = a
        end
        parts[#parts + 1] = line:sub(col, col)
    end
    print(string.format("L%-3d %s", row, table.concat(parts)))
end
vim.cmd("qa!")
