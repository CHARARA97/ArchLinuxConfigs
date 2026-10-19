-- Probe: which captures apply to doxygen tags, and which injected langs are active
if os.getenv("TS_RTP") then
    vim.opt.rtp:prepend(os.getenv("TS_RTP"))
end

local path = vim.fn.fnamemodify(arg[1], ":p")
local lines = vim.fn.readfile(arg[1])

vim.cmd("edit " .. vim.fn.fnameescape(path))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
-- force a synchronous parse so the tree is populated for probing
local parser = vim.treesitter.get_parser(buf)
parser:parse(true)

print("TS_RTP = " .. tostring(os.getenv("TS_RTP") or "<none>"))
local h = vim.treesitter.highlighter.active[buf]
print("injected/active trees in highlighter:")
h.tree:for_each_tree(function(tstree, tree)
    print(string.format("   lang=%s root=%s", tree:lang(), tstree and tstree:root():type() or "nil"))
end)

local function caps_at(row, col)
    local out = {}
    for _, c in ipairs(vim.treesitter.get_captures_at_pos(buf, row, col)) do
        out[#out + 1] = string.format("%s@%s", c.capture, c.lang or "?")
    end
    return #out > 0 and table.concat(out, ",") or "<none>"
end

print("---- captures at the '@' of each doc tag ----")
for i = 1, #lines do
    local line = lines[i]
    local atcol = line:find("@", 1, true)
    if atcol then
        print(string.format("L%-3d %-24s -> %s", i, line:sub(atcol):gsub("%s+$", ""), caps_at(i - 1, atcol - 1)))
    end
end
vim.cmd("qa!")
