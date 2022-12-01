vim.opt.path:append { "**" }
vim.opt.wildmenu = true

vim.opt.clipboard = "unnamedplus"

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.textwidth = 79
vim.opt.wrap = true

vim.opt.number = true

vim.opt.colorcolumn:append { "80" }

vim.opt.showmode = false

vim.opt.list = true
vim.opt.listchars = {
  space = '.',
  tab = '▸ ',
  extends = '❯',
  precedes = '❮',
  nbsp = '+',
  trail = '-'
}
