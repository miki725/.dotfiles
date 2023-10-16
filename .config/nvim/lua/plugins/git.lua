return {
    -- git commit window
    { "rhysd/committia.vim" },
    -- for interactive rebase
    { "hotwatermorning/auto-git-diff" },
    {
        "ruifm/gitlinker.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>gy",
                function()
                    require("gitlinker").get_buf_range_url(string.lower(vim.fn.mode()), {
                        add_current_line_on_normal_mode = true,
                    })
                end,
                mode = { "n", "v" },
                desc = "Copy line/selection git link [GitLinker]",
            },
            {
                "<leader>gY",
                function()
                    require("gitlinker").get_buf_range_url(string.lower(vim.fn.mode()), {
                        add_current_line_on_normal_mode = false,
                    })
                end,
                mode = { "n", "v" },
                desc = "Copy file git link [GitLinker]",
            },
        },
    },
}
