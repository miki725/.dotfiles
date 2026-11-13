return {
    -- diagnostics for cursor line as inline popup at end of line
    -- without covering other floats like hover or signature help
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        init = function()
            -- plugin only draws inline popup so sign column icons are configured here
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                        [vim.diagnostic.severity.HINT] = "󰌵",
                    },
                },
                -- errors win over warnings in sign column
                severity_sort = true,
            })
        end,
        opts = {
            options = {
                show_source = {
                    enabled = true,
                },
                -- wrap long messages instead of running off screen
                multilines = {
                    enabled = true,
                },
            },
        },
    },
}
