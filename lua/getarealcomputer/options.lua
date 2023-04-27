vim.g.neon_style = "dark"

local opt = vim.opt

opt.termguicolors = true
opt.cursorline = true
opt.path:append { "**" }
opt.wildmenu = true

opt.fileencoding = "utf-8"

opt.clipboard = "unnamedplus"

opt.completeopt = { 'menu', 'menuone', 'noselect' }

opt.undofile = true

opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.textwidth = 79
opt.wrap = true

opt.number = true

opt.colorcolumn:append { "80" }

opt.showmode = false

opt.list = true
opt.listchars = {
  space = '⋅',
  eol = '↴',
  tab = '▸ ',
  extends = '❯',
  precedes = '❮',
  nbsp = '+',
  trail = '-'
}
