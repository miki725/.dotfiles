return {
    {
        "vim-scripts/QFEnter",
        ft = { "qf" },
        init = function()
            vim.g.qfenter_vopen_map = { "<C-v>" }
            vim.g.qfenter_hopen_map = { "<C-CR>", "<C-s>", "<C-x>" }
            vim.g.qfenter_topen_map = { "<C-t>" }
        end,
    },
    {
        "stevearc/quicker.nvim",
        ft = { "qf" },
        opts = {
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({
                            before = 1,
                            after = 1,
                            add_to_existing = true,
                        })
                    end,
                    desc = "Expand quickfix content",
                },
                {
                    "<",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Collapse quickfix content",
                },
            },
        },
    },
    {
        "miki725/vim-ripgrep",
        init = function()
            vim.g.rg_command = "rg --vimgrep -S"
            vim.g.rg_highlight = 1
            vim.g.rg_apply_mappings = 0
        end,
        cmd = "Rg",
    },
}
