-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- toggle between number and relativenumber on normal or insert
local numbertoggle_id = vim.api.nvim_create_augroup("numbertoggle", {
  clear = true
})
vim.api.nvim_create_autocmd({
  "BufEnter", "FocusGained", "InsertLeave", "WinEnter"
}, {
  group = numbertoggle_id,
  pattern = '*',
  command = 'if &nu && mode() != "i" | set rnu   | endif'
})

vim.api.nvim_create_autocmd({
  "BufLeave", "FocusLost", "InsertEnter", "WinLeave"
}, {
  group = numbertoggle_id,
  pattern = '*',
  command = 'if &nu != "i" | set nornu | endif'
})
