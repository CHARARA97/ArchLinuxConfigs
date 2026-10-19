if os.getenv("TS_RTP") then vim.opt.rtp:prepend(os.getenv("TS_RTP")) end
vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(arg[1], ":p")))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)
pcall(vim.api.nvim__redraw, { buf = buf, flush = true, valid = true })
local ns_all = vim.api.nvim_get_namespaces()
for name, ns in pairs(ns_all) do
  if name:lower():find("treesitter") then
    local marks = vim.api.nvim_buf_get_extmarks(buf, ns, { 1, 0 }, { 3, -1 }, { details = true })
    print(string.format("ns=%s (%d) marks=%d", name, ns, #marks))
    for _, m in ipairs(marks) do
      local row, col, d = m[2], m[3], m[4]
      if row == 1 then
        print(string.format("   row%d col%d-%d hl=%s prio=%s", row, col, d.end_col, tostring(d.hl_group), tostring(d.priority)))
      end
    end
  end
end
vim.cmd("qa!")
