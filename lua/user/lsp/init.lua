local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

  keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
  keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
  keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
  keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

  keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

local on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "sumneko_lua" then
    client.server_capabilities.documentFormattingProvider = false
  end

  lsp_keymaps(bufnr)
end

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local servers = {
  "quick_lint_js",
  "sumneko_lua",
  "rust_analyzer",
  "tsserver",
}

local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  return
end
mason.setup()

require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- After setting up mason-lspconfig you may set up servers via lspconfig

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = on_attach,
    capabilities = capabilities
  }

  local server_name = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server_name)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  lspconfig[server].setup(opts)
end

--require("lspconfig").sumneko_lua.setup {}
--require("lspconfig").rust_analyzer.setup {}
--require("lspconfig").tsserver.setup {}
