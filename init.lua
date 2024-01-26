--[[
-- Set color scheme
--]]
vim.cmd("colorscheme default")

--[[
-- Vim options in lua
--]]
local opt = vim.opt

opt.termguicolors = true
opt.cursorline = true
opt.path:append({ "**" })
opt.wildmenu = true

opt.fileencoding = "utf-8"

opt.clipboard = "unnamedplus"

opt.completeopt = { "menu", "menuone", "noselect" }

opt.undofile = true

opt.expandtab = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.textwidth = 79
opt.wrap = true

opt.number = true

opt.colorcolumn:append({ "80" })

opt.showmode = false

opt.list = true
--opt.listchars = {
--    space = ".",
--    eol = "↴",
--    tab = "▸ ",
--    extends = "❯",
--    precedes = "❮",
--    nbsp = "+",
--    trail = "-",
--}

--[[
-- Resize splits if window got resized
--]]
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

--[[
-- Toggle between number and relativenumber on normal or insert
--]]
local numbertoggle_id = vim.api.nvim_create_augroup("numbertoggle", {
    clear = true,
})
vim.api.nvim_create_autocmd({
    "BufEnter",
    "FocusGained",
    "InsertLeave",
    "WinEnter",
}, {
    group = numbertoggle_id,
    pattern = "*",
    command = 'if &nu && mode() != "i" | set rnu   | endif',
})
vim.api.nvim_create_autocmd({
    "BufLeave",
    "FocusLost",
    "InsertEnter",
    "WinLeave",
}, {
    group = numbertoggle_id,
    pattern = "*",
    command = 'if &nu != "i" | set nornu | endif',
})

--[[
-- Install lazy.nvim as package manager in path
--]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
opt.rtp:prepend(lazypath)

--[[
-- Call lazy.nvim
--]]
local plugins = {
    --colorscheme
    {
        "ofirgall/ofirkai.nvim",
        name = "ofirkai",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme ofirkai")
        end,
    },
    -- LSP config
    "neovim/nvim-lspconfig",
    -- LSP setup helper
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- treesitter
    "nvim-treesitter/nvim-treesitter",
    -- LSP progress notification
    "j-hui/fidget.nvim",
    -- formatter
    "mhartington/formatter.nvim",
    -- nvim.cmp
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-nvim-lua",
    "onsails/lspkind.nvim",
}
require("lazy").setup(plugins)

--[[
-- Fidget, LSP progress notification setup
--]]
require("fidget").setup({})

--[[
-- Formatter setup config
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
--]]
require("formatter").setup({
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
        lua = {
            require("formatter.filetypes.lua").stylua,
        },
        python = {
            require("formatter.filetypes.python").black,
        },
        typescript = {
            require("formatter.filetypes.typescript").prettierd,
        },
        typescriptreact = {
            require("formatter.filetypes.typescriptreact").prettierd,
        },
        javascript = {
            require("formatter.filetypes.javascript").prettierd,
        },
        javascriptreact = {
            require("formatter.filetypes.javascriptreact").prettierd,
        },

        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

--[[
-- Set up nvim-cmp.
--]]
local cmp = require("cmp")
cmp.setup({
    view = {
        entries = "custom",
    },
    formatting = {
        fields = {
            --"kind",
            "abbr",
            "menu",
        },
        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({
                mode = "symbol_text",
                maxwidth = 80,
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
        end,
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        --completion = cmp.config.window.bordered(),
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = 0,
            site_padding = 0,
        },
        --documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "vsnip" }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = "buffer" },
    }),
})
-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = "buffer" },
    }),
})
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = "path" },
--     }, {
--         { name = "cmdline" },
--     }),
-- })

--[[
-- Language server protocols setup
-- ]]
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").tsserver.setup({
    capabilities = capabilities,
})
require("lspconfig").lua_ls.setup({
    capabilities = capabilities,
    globals = { "vim" },
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if
            not vim.loop.fs_stat(path .. "/.luarc.json")
            and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
        then
            client.config.settings =
                vim.tbl_deep_extend("force", client.config.settings, {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = "LuaJIT",
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                -- "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            },
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        },
                    },
                })

            client.notify(
                "workspace/didChangeConfiguration",
                { settings = client.config.settings }
            )
        end
        return true
    end,
})
require("lspconfig").pylsp.setup({
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { "W391" },
                    maxLineLength = 80,
                },
                rope_completion = {
                    enabled = false,
                    eager = false,
                },
            },
        },
    },
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set(
            "n",
            "<space>wr",
            vim.lsp.buf.remove_workspace_folder,
            opts
        )
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})
