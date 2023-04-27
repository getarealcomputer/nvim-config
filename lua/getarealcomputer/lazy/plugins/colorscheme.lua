return {

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
  {
    "glepnir/zephyr-nvim",
    lazy = true,
    name = "zephyr"
  },
  {
    "tanvirtin/monokai.nvim",
    lazy = false,
    priority = 1000,
    name = "monokai",
    config = function()
      vim.cmd([[colorscheme monokai_ristretto]])
    end,
  },
  {
    "rafamadriz/neon",
    lazy = true,
  }
}
