local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path
    })
    print("Installing packer, close and reopen Neovim...")
    -- vim.cmd[['packadd packer.nvim']]
    vim.cmd.packadd('packer.nvim')
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- the package manager itself
  use({ 'wbthomason/packer.nvim' })

  -- auto complete
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- required by nvim-cmp, for snippets
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  -- LSP(Language Server Protocol) and its config
  use({
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  })

  -- Treesitter    
  use {
    'nvim-treesitter/nvim-treesitter',
    tag = 'v0.8.1',
    -- run = ':TSUpdate'
  }

  -- Formatter
  use({ "mhartington/formatter.nvim" })

  -- Linter for language not covered by nvim-lspconfig
  use({ "mfussenegger/nvim-lint" })

  -- Web dev icons
  use({ "nvim-tree/nvim-web-devicons" })

  -- DAP(Debug Adapter Protocol)
  use({ "mfussenegger/nvim-dap" })

  -- Java eclipse
  use({ "mfussenegger/nvim-jdtls" })

  -- colorschemes
  use({
    'glepnir/zephyr-nvim',
    requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
  })
  use { "folke/tokyonight.nvim" }
  use { "lunarvim/darkplus.nvim" }

  -- the best fuzzy finder.?
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- greeter screen
  use({ 'goolord/alpha-nvim' })

  -- status line
  use({ 'nvim-lualine/lualine.nvim' })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
