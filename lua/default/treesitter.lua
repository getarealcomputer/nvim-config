local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup({
  ensure_installed = {
    "c", "lua", "vim", "help", "bash", "javascript", "json",
    "python", "typescript", "tsx",
    "css", "rust", "java", "yaml", "markdown", "markdown_inline",
  }, -- one of "all" or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "python", "css" } },
})
