vim.opt.rtp:prepend(os.getenv("TS_RTP"))          -- parser + upstream doxygen queries
vim.opt.rtp:append(os.getenv("TS_RTP_AFTER"))     -- our "after" overrides (loaded last)
vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(arg[1], ":p")))
local buf = vim.api.nvim_get_current_buf()
pcall(vim.treesitter.start, buf)
vim.treesitter.get_parser(buf):parse(true)
local line = vim.fn.readfile(arg[1])[3]
for col = 4, 12 do
  local out = {}
  for _, c in ipairs(vim.treesitter.get_captures_at_pos(buf, 2, col - 1)) do
    out[#out + 1] = c.capture .. "(p" .. tostring(c.metadata.priority or "-") .. ")"
  end
  print(string.format("'%s' -> %s", line:sub(col, col), table.concat(out, ",")))
end
vim.cmd("qa!")
