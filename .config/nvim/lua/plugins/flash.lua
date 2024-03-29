return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = {
                    enabled = false, -- toggle with keymap below
                },
            },
        },
        keys = {
            {
                "<leader>f",
                mode = { "n", "o", "x" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash Find [Flash]",
            },
            {
                "<leader>t",
                mode = { "o" },
                function()
                    require("flash").jump({ jump = { inclusive = false } })
                end,
                desc = "Flash Until [Flash]",
            },
            {
                "<leader>F",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter [Flash]",
            },
            {
                "<leader>*",
                mode = { "n" },
                function()
                    require("flash").jump({
                        pattern = vim.fn.expand("<cword>"),
                    })
                end,
                desc = "Search Current Word [Flash]",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash [Flash]",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search [Flash]",
            },
            {
                "<leader>f", -- during search (/) this toggles flash
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search [Flash]",
            },
        },
    },
}
