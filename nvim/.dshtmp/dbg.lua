local path = vim.fn.fnamemodify(arg[1], ":p")
vim.cmd("edit " .. vim.fn.fnameescape(path))
local buf = vim.api.nvim_get_current_buf()
print("buf=" .. buf .. " ft=" .. vim.bo[buf].filetype)
local h = vim.treesitter.highlighter.active[buf]
print("highlighter = " .. tostring(h))
print("h.tree = " .. tostring(h and h.tree))
print("is_parser = " .. tostring(h and vim.treesitter.highlighter.active[buf] and h.tree ~= nil))
if h and h.tree then
  local ok, err = pcall(function()
    h.tree:for_each_tree(function(tstree, tree)
      print("  tree lang=" .. tree:lang() .. " tstree=" .. tostring(tstree ~= nil))
    end)
  end)
  print("for_each_tree ok=" .. tostring(ok) .. " err=" .. tostring(err))
end
print("caps at 2,4 = " .. vim.inspect(vim.treesitter.get_captures_at_pos(buf, 1, 4)))
vim.cmd("qa!")
