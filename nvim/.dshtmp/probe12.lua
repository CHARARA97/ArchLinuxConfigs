if os.getenv("TS_RTP") then vim.opt.rtp:prepend(os.getenv("TS_RTP")) end
vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(arg[1], ":p")))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)

local seen, hl_defs, grid_cells = {}, {}, {}
local ns = vim.api.nvim_create_namespace("dsh_ui")
local ok, err = pcall(vim.ui_attach, ns, { ext_hlstate = true }, function(ev, ...)
  seen[ev] = (seen[ev] or 0) + 1
  if ev == "hl_attr_define" then
    local id, rgb = ...
    hl_defs[id] = rgb
  elseif ev == "grid_line" then
    local grid, row, col_start, cells = ...
    grid_cells[#grid_cells + 1] = { grid = grid, row = row, col = col_start, cells = cells }
  end
end)
print("ui_attach ok=" .. tostring(ok) .. " err=" .. tostring(err))
vim.cmd("redraw")
vim.api.nvim__redraw({ buf = buf, flush = true, valid = true })
vim.cmd("redraw")
local names = vim.tbl_keys(seen)
table.sort(names)
for _, n in ipairs(names) do print(string.format("  event %-20s x%d", n, seen[n])) end
print("hl_attr_define entries = " .. vim.tbl_count(hl_defs))
print("sample hl defs:")
local i = 0
for id, rgb in pairs(hl_defs) do
  i = i + 1
  if i <= 6 then print(string.format("   id=%-4d fg=%-10s bg=%-10s bold=%s italic=%s", id, tostring(rgb.foreground), tostring(rgb.background), tostring(rgb.bold), tostring(rgb.italic))) end
end
vim.cmd("qa!")
