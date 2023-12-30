return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<leader>br",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Debugger Breakpoint",
            },
            {
                "<leader>c",
                function()
                    require("dap").continue()
                end,
                desc = "Debug Continue",
            },
            {
                "<leader>so",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug Step Over",
            },
            {
                "<leader>si",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug Step Into",
            },
            {
                "<leader>r",
                function()
                    require("dap").repl.open()
                end,
                desc = "Open REPL",
            },
            {
                "<leader>R",
                function()
                    require("dap").repl.close()
                end,
                desc = "Close REPL",
            },
        },
    },
}
