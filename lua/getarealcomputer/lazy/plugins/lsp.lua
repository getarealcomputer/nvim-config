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
        --cond = function()
        --  return require("lazy.core.config").plugins["cmp"] ~= nil
        --end
      },
    },
    keys = {
      { "<leader>li", "<cmd>LspInfo<cr>", desc = "Open LSP Info" }
    },
    opts = {
      servers = {
        tsserver = {},
        gopls = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              library = vim.api.nvim_get_runtime_file("", true),
              telemetry = { enable = false }
            }
          }
        }
      },
    },
    config = function(_, opts)
      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities)
        }, servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end

      local ensure_installed_table = {}
      for server, _ in pairs(servers) do
        setup(server)
        ensure_installed_table[#ensure_installed_table + 1] = server
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed_table
      })
    end
  },
  -- mason (lsp server installer)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "stylua", "shfmt", "flake8", "tsserver"
      }
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end
  },
  -- formatter
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local null_ls = require("null-ls")
      return {
        sources = {
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.stylua
        },
        on_attach = function(client, bufnr)
          local format_id = vim.api.nvim_create_augroup("LspFormatting", {})
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = format_id, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = format_id,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end
            })
          end
        end
      }
    end
  }
}
