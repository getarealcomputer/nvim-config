local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "chrisatmachine.lsp.mason"
require("chrisatmachine.lsp.handlers").setup()
require "chrisatmachine.lsp.null-ls"
