return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            enabled = true,
            exclude = {
                filetypes = {
                    "help",
                    "man",
                    "lspinfo",
                    "packer",
                    "checkhealth",
                    "gitcommit",
                    "TelescopePrompt",
                    "TelescopeResults",
                },
            },
        },
        config = function(_, opts)
            require("ibl").setup(opts)
        end,
    },
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            draw = {
                delay = 1,
            },
            -- symbol = "▏",
            symbol = "│",
            options = { try_as_border = true },
        },
        config = function(_, opts)
            require("mini.indentscope").setup(opts)
        end,
    },
}
