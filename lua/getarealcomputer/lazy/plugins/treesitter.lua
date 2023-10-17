return {
    {
        "nvim-treesitter/nvim-treesitter",
        --version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        --event = { "LazyFile", "VeryLazy" },
        opts = {
            highlight = { enable = true },
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "regex",
                "typescript",
                "javascript",
                "go",
                "rust",
                "solidity",
                "http",
                "json",
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
