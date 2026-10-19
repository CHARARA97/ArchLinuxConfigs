-- Probe treesitter captures / highlight groups in a C++ buffer
local path = vim.fn.fnamemodify(arg[1], ":p")
local lines = vim.fn.readfile(arg[1])

vim.cmd("edit " .. vim.fn.fnameescape(path))
local buf = vim.api.nvim_get_current_buf()
local ft = vim.bo[buf].filetype
print("filetype = " .. ft)
print("ts active = " .. tostring(vim.treesitter.highlighter.active[buf] ~= nil))
local ok, err = pcall(vim.treesitter.start, buf)
print("start ok = " .. tostring(ok) .. " " .. tostring(err))
print("ts active after start = " .. tostring(vim.treesitter.highlighter.active[buf] ~= nil))

local ok2, parser = pcall(vim.treesitter.get_parser, buf, "cpp")
if ok2 then
    local tree = parser:parse()[1]
    print("root = " .. tree:root():type())
end

local function caps_at(row, col)
    local names = {}
    for _, c in ipairs(vim.treesitter.get_captures_at_pos(buf, row, col)) do
        names[#names + 1] = c.capture
    end
    return #names > 0 and table.concat(names, ",") or "<none>"
end

print("---- captures at '@' and at first content char ----")
for i = 1, #lines do
    local line = lines[i]
    if line:find("@", 1, true) then
        local atcol = line:find("@", 1, true)
        print(string.format("L%d col%d '@' -> %s", i, atcol, caps_at(i - 1, atcol - 1)))
        local mc = line:find("[^%s/*]")
        if mc then
            print(string.format("L%d col%d '%s' -> %s", i, mc, line:sub(mc, mc + 10), caps_at(i - 1, mc - 1)))
        end
    end
end

print("---- highlight groups ----")
for _, g in ipairs({ "@comment", "@comment.documentation", "@comment.todo", "@comment.note", "@comment.warning", "@comment.error", "@spell", "@markup.raw.block" }) do
    local h = vim.api.nvim_get_hl(0, { name = g, link = false })
    print(string.format("%-26s %s", g, (vim.inspect(h):gsub("%s+", " "))))
end
vim.cmd("qa!")
