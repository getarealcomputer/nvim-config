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
            -- LSP notificatio
            --{
            --    "nvim-lua/lsp-status.nvim",
            --},
        },
        keys = {
            { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP Info" },
            {
                "<space>e",
                vim.diagnostic.open_float,
                desc = "Line Diagnostics",
            },
            {
                "<space>d",
                vim.diagnostic.setloclist,
                desc = "Diagnostics Location List",
            },
            {
                "[d",
                vim.diagnostic.goto_prev,
                desc = "Next Diagnostic",
            },
            {
                "]d",
                vim.diagnostic.goto_next,
                desc = "Previous Diagnostic",
            },
            { "<leader>K", vim.lsp.buf.hover, desc = "Hover" },
            {
                "<c-k>",
                vim.lsp.buf.signature_help,
                desc = "Signature Help",
            },
            {
                "<leader>gd",
                vim.lsp.buf.definition,
                desc = "Go to Declaration",
            },
            {
                "<leader>gD",
                vim.lsp.buf.declaration,
                desc = "Go to Definition",
            },
            {
                "<leader>gi",
                vim.lsp.buf.implementation,
                desc = "Go to Implementation",
            },
            {
                "<leader>f",
                vim.lsp.buf.format,
                desc = "Format Document",
            },
        },
        opts = {
            servers = {
                tsserver = {
                    cmd = {
                        "typescript-language-server",
                        "--stdio",
                    },
                },
                pyright = {},
                gopls = {},
                clangd = {},
                rust_analyzer = {},
                jsonls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                            },
                            diagnostics = {
                                globals = {
                                    "vim",
                                    "util",
                                },
                            },
                            library = vim.api.nvim_get_runtime_file("", true),
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                },
                intelephense = {},
            },
            diagnostics = {
                float = { border = "single" },
            },
        },
        config = function(_, opts)
            local servers = opts.servers
            --local lsp_status = require("lsp-status")
            --lsp_status.register_progress()

            -- diagnostics
            for name, icon in
                pairs(require("getarealcomputer.config.icons").diagnostics)
            do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, {
                    text = icon,
                    texthl = name,
                    numhl = "",
                })
            end

            vim.lsp.handlers["textDocument/hover"] =
                vim.lsp.with(vim.lsp.handlers.hover, {
                    border = "single",
                })

            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, {
                    border = "single",
                })
            vim.diagnostic.config(opts.diagnostics)

            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                    --on_attach = lsp_status.on_attach,
                    --capabilities = lsp_status.capabilities,
                }, servers[server] or {})

                require("lspconfig")[server].setup(server_opts)
            end

            local ensure_installed_table = {}

            for server, _ in pairs(servers) do
                setup(server)
                ensure_installed_table[#ensure_installed_table + 1] = server
            end

            require("lspconfig").solidity.setup({
                root_dir = require("lspconfig").util.root_pattern(
                    ".git",
                    "package.json",
                    "foundry.toml"
                ),
            })

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
            ensure_installed = {},
        },
        config = function(_, opts)
            require("mason").setup(opts)
        end,
    },
    -- formatter
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>f",
                function()
                    require("conform").format({
                        async = true,
                        lsp_fallback = false,
                    })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        -- Everything in opts will be passed to setup()
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "blackd", "black" },
                javascript = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                javascriptreact = { { "prettierd", "prettier" } },
                go = { "golines", "goimports", "gofmt" },
            },
            -- Set up format-on-save
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            -- Customize formatters
            formatters = {
                golines = {
                    prepend_args = { "-m", "80" },
                },
            },
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
    -- formatter
    -- {
    --     "mhartington/formatter.nvim",
    --     opts = {
    --         logging = true,
    --     },
    --     config = function(_, opts)
    --         require("formatter").setup({
    --             logging = opts.logging,
    --             filetype = {
    --                 -- Formatter configurations for filetype "lua" go here
    --                 -- and will be executed in order
    --                 lua = {
    --                     -- "formatter.filetypes.lua" defines default configurations for the
    --                     -- "lua" filetype
    --                     require("formatter.filetypes.lua").stylua,
    --                 },
    --                 javascript = {
    --                     require("formatter.filetypes.javascript").prettierd,
    --                 },
    --                 typescript = {
    --                     require("formatter.filetypes.typescript").prettierd,
    --                 },
    --                 javascriptreact = {
    --                     require("formatter.filetypes.javascriptreact").prettierd,
    --                 },
    --             },
    --         })
    --     end,
    -- },
    --legacy dependencies (FOR ARCHIVE ONLY)
    --{
    --  "jose-elias-alvarez/null-ls.nvim",
    --  event = { "BufReadPre", "BufNewFile" },
    --  dependencies = { "mason.nvim" },
    --  opts = function()
    --    local nls = require("null-ls")
    --    return {
    --      sources = {
    --        nls.builtins.formatting.prettierd,
    --        nls.builtins.formatting.stylua,
    --        nls.builtins.diagnostics.solhint,
    --        nls.builtins.diagnostics.golangci_lint,
    --      },
    --      debug = true,
    --    }
    --  end,
    --},
    -- java language server protocol
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },
    -- LSP progress status
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = function()
            require("fidget").setup({})
        end,
    },
}
