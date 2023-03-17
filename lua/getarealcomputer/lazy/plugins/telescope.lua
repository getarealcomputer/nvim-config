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
      }
    }
  }
}
