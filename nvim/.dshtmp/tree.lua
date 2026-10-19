-- Dump the doxygen parse tree for a row range, highlighting ERROR / MISSING nodes
local file, lang, row0, row1 = arg[1], arg[2] or "doxygen", tonumber(arg[3]) or 0, tonumber(arg[4]) or 100
vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(file, ":p")))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
local parser = vim.treesitter.get_parser(buf)
parser:parse(true)

local found = false
parser:for_each_tree(function(tstree, tree)
    if tree:lang() ~= lang then
        return
    end
    found = true
    local root = tstree:root()
    local sr, sc, er, ec = root:range()
    if er < row0 or sr > row1 then
        return
    end
    print(string.format("== %s tree [%d,%d]-[%d,%d] ==", lang, sr, sc, er, ec))
    local function walk(node, depth)
        local a, b, c, d = node:range()
        if c < row0 or a > row1 then
            return
        end
        local ty = node:type()
        local mark = (ty == "ERROR" or node:missing()) and "  <<<<<< ERROR/MISSING" or ""
        local text = vim.treesitter.get_node_text(node, buf):gsub("\n", "\\n")
        if #text > 42 then
            text = text:sub(1, 42) .. "..."
        end
        print(string.format("%s%-26s [%d:%d-%d:%d] kids=%d named=%d %s%s", string.rep("  ", depth), ty, a, b, c, d, node:child_count(), node:named_child_count(), text, mark))
        for i = 0, node:child_count() - 1 do
            walk(node:child(i), depth + 1)
        end
    end
    walk(root, 0)
end)
if not found then
    print("no " .. lang .. " tree found")
end
vim.cmd("qa!")
