if os.getenv("TS_RTP") then vim.opt.rtp:prepend(os.getenv("TS_RTP")) end
local path = vim.fn.fnamemodify(arg[1], ":p")
local lines = vim.fn.readfile(arg[1])
vim.cmd("edit " .. vim.fn.fnameescape(path))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)

-- attach a dummy UI so redraw (and thus the TS decoration provider) actually runs
local ns_ui = vim.api.nvim_create_namespace("dsh_probe_ui")
vim.ui_attach(ns_ui, {}, function() end)
pcall(vim.api.nvim__redraw, { buf = buf, flush = true, valid = true })
vim.cmd("redraw")

local hl_ns
for name, id in pairs(vim.api.nvim_get_namespaces()) do
  if name == "nvim.treesitter.highlighter" then hl_ns = id end
end
print("ts hl namespace = " .. tostring(hl_ns))
local marks = vim.api.nvim_buf_get_extmarks(buf, hl_ns, { 0, 0 }, { -1, -1 }, { details = true })
print("extmarks = " .. #marks)
local by_row = {}
for _, m in ipairs(marks) do
  local row, col, d = m[2], m[3], m[4]
  by_row[row] = by_row[row] or {}
  table.insert(by_row[row], { col = col, end_col = d.end_col, hl = d.hl_group, prio = d.priority })
end
for row = 0, math.min(#lines - 1, 30) do
  local rowmarks = by_row[row]
  if rowmarks then
    table.sort(rowmarks, function(a, b) return a.col < b.col end)
    local parts = {}
    for _, r in ipairs(rowmarks) do
      parts[#parts + 1] = string.format("%d-%d:%s", r.col, r.end_col, tostring(r.hl))
    end
    print(string.format("L%-3d %s", row + 1, table.concat(parts, " ")))
  end
end
vim.cmd("qa!")
