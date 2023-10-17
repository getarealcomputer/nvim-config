return {

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    opts = { style = "moon" },
    lazy = true,
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
  {
    "glepnir/zephyr-nvim",
    lazy = true,
    name = "zephyr"
  },
  {
    "tanvirtin/monokai.nvim",
    lazy = true,
    name = "monokai",
  },
  {
    "rafamadriz/neon",
    lazy = true,
  }
}
