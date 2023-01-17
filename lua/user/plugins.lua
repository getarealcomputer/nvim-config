local fn = vim.fn
local install_path = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(install_path) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    install_path,
  })
end
vim.opt.rtp:prepend(install_path)

return require('lazy').setup({
  {-- auto complete
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',

      -- required by nvim-cmp, for snippets
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',

      -- snippets collection
      'rafamadriz/friendly-snippets',
    },
  },

  {-- LSP(Language Server Protocol) and its config
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  },

  {-- Treesitter    
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end
  },

  { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  },

  { -- Formatter, linter, Debug Adapter Protocol
    'mhartington/formatter.nvim',
    'mfussenegger/nvim-lint',
    'mfussenegger/nvim-dap', 
    'mfussenegger/nvim-jdtls',
    dependencies = {
     'nvim-tree/nvim-web-devicons',
    },
  },

  {-- colorschemes
    'glepnir/zephyr-nvim',
    'folke/tokyonight.nvim',
    'lunarvim/darkplus.nvim',
    'navarasu/onedark.nvim' -- Theme inspired by Atom
  },

  {-- the best fuzzy finder?
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  -- or                            , branch = '0.1.x',
    dependencies = {'nvim-lua/plenary.nvim'},
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 },

  -- greeter screen
  { 'goolord/alpha-nvim' },

  -- status line
  { 'nvim-lualine/lualine.nvim' },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',

  'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
