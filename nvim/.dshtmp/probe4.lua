if os.getenv("TS_RTP") then
    vim.opt.rtp:prepend(os.getenv("TS_RTP"))
end
local lines = vim.fn.readfile(arg[1])
vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(arg[1], ":p")))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)

local function caps_at(row, col)
    local out = {}
    for _, c in ipairs(vim.treesitter.get_captures_at_pos(buf, row, col)) do
        out[#out + 1] = c.capture
    end
    return table.concat(out, ",")
end
for _, row in ipairs({ 2, 3, 4, 7, 11 }) do
    local line = lines[row]
    if line then
        print(string.format("L%-3d %s", row, line))
        for col = 1, #line do
            local c = caps_at(row - 1, col - 1)
            if c ~= "" then
                print(string.format("      col%-3d %-12s | %s", col, "'" .. line:sub(col, col) .. "'", c))
            end
        end
    end
end
vim.cmd("qa!")
