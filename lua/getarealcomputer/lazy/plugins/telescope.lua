return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    keys = {
      {
        "<leader>,",
        "<cmd>Telescope buffers show_all_buffers=true<cr>",
        desc = "Switch Buffer"
      },
      {
        "<leader>ff",
        "<cmd>Telescope find_files<cr>",
        desc = "Find File"
      },
      {
        "<leader>fg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Search File"
      },
    }
  }
}
