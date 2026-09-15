return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            -- replaces alpha-nvim
            dashboard = {
                sections = {
                    { section = "header" },
                    { section = "keys", gap = 1, padding = 1 },
                    { section = "recent_files", limit = 10, indent = 2, padding = 1 },
                    { section = "startup" },
                },
            },
            -- replaces indent-blankline
            indent = { enabled = true },
            -- lsp-only, no treesitter/regex fallback (illuminate handles non-lsp files like markdown)
            words = { enabled = false },
            -- replaces goyo + limelight
            zen = {
                win = {
                    width = 83,
                    backdrop = { transparent = false, blend = 0 },
                    wo = {
                        winhighlight = "NormalFloat:Normal",
                        number = false,
                        relativenumber = false,
                        signcolumn = "no",
                    },
                },
                show = { statusline = false, tabline = false },
                toggles = { dim = false },
            },
            notifier = { enabled = true },
            bigfile = { enabled = true },
            input = { enabled = true },
            animate = { enabled = false },
            scroll = { enabled = false },
        },
        keys = {
            {
                "<leader>z",
                function()
                    Snacks.zen()
                end,
                desc = "Toggle Zen Mode [Snacks.zen]",
            },
        },
    },
}
