for _, g in ipairs({ '@none', '@none.doxygen', '@markup.italic', '@markup.italic.doxygen', '@punctuation.delimiter', '@punctuation.delimiter.doxygen' }) do
  local plain = vim.api.nvim_get_hl(0, { name = g, link = false })
  local link = vim.api.nvim_get_hl(0, { name = g, link = true })
  print(string.format("%-30s link=%-24s attrs=%s", g, tostring(link.link), (vim.inspect(plain):gsub("%s+", " "))))
end
print("Normal fg = " .. string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg or -1))
print("hl.priorities.treesitter = " .. tostring(vim.hl.priorities.treesitter))
vim.cmd("qa!")
