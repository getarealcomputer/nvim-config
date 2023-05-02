return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    keys = {
      { "<leader>li", "<cmd>LspInfo<cr>",         desc = "LSP Info" },
      { "<space>e",   vim.diagnostic.open_float,  desc = "Line Diagnostics" },
      { "<space>d",   vim.diagnostic.setloclist,  desc = "Diagnostics Location List" },
      { "[d",         vim.diagnostic.goto_prev,   desc = "Next Diagnostic" },
      { "]d",         vim.diagnostic.goto_next,   desc = "Previous Diagnostic" },
      { "<leader>K",  vim.lsp.buf.hover,          desc = "Hover" },
      { "<c-k>",      vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "<leader>gd", vim.lsp.buf.definition,     desc = "Go to Declaration" },
      { "<leader>gD", vim.lsp.buf.declaration,    desc = "Go to Definition" },
      { "<leader>gi", vim.lsp.buf.implementation, desc = "Go to Implementation" },
      { "<leader>f",  vim.lsp.buf.format,         desc = "Format Document" },
    },
    opts = {
      servers = {
        tsserver = {
          cmd = {
            "typescript-language-server",
            "--stdio",
          },
        },
        --eslint = {},
        gopls = {},
        clangd = {},
        rust_analyzer = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              library = vim.api.nvim_get_runtime_file("", true),
              telemetry = { enable = false },
            },
          },
        },
        intelephense = {},
        solc = {},
      },
    },
    config = function(_, opts)
      local servers = opts.servers
      -- diagnostics
      for name, icon in pairs(require("getarealcomputer.config.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)
      local capabilities =
          require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end

      local ensure_installed_table = {}
      for server, _ in pairs(servers) do
        setup(server)
        ensure_installed_table[#ensure_installed_table + 1] = server
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed_table,
      })
    end,
  },
  -- mason (lsp server installer)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "flake8",
        "tsserver",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
  -- formatter
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },
  -- java language server protocol
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
