Config.new_autocmd("TextYankPost", nil, function()
  vim.hl.on_yank()
end, "Highlight when yanking (copying) text")

Config.new_autocmd("BufReadPost", nil, function(event)
  local exclude = { "gitcommit" }
  local buf = event.buf
  if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
    return
  end
  vim.b[buf].lazyvim_last_loc = true
  local mark = vim.api.nvim_buf_get_mark(buf, '"')
  local lcount = vim.api.nvim_buf_line_count(buf)
  if mark[1] > 0 and mark[1] <= lcount then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
  end
end)


Config.new_autocmd("InsertEnter", nil, function()
  vim.wo.cursorline = false
  vim.wo.relativenumber = false
  vim.wo.number = true -- keep absolute numbers
end)

Config.new_autocmd("InsertLeave", nil, function()
  vim.wo.cursorline = true
  vim.wo.relativenumber = true
end)

Config.new_autocmd("FileType", { "man" }, function(event)
  vim.bo[event.buf].buflisted = false
end)
