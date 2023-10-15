local telescope_utils = require("utils.telescope")

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            telescope_utils.register({
                -- "OliverChao/telescope-picker-list.nvim",
                -- https://github.com/OliverChao/telescope-picker-list.nvim/pull/1
                "miki725/telescope-picker-list.nvim",
                extensions = {
                    picker_list = {
                        order = 1000, -- last extension
                        excluded_pickers = {
                            "fzf",
                            "fd",
                        },
                    },
                },
            }),
            telescope_utils.register({
                -- "LukasPietzschmann/telescope-tabs",
                -- https://github.com/LukasPietzschmann/telescope-tabs/pull/18
                "miki725/telescope-tabs",
                extensions = {
                    ["telescope-tabs"] = {},
                },
            }),
            telescope_utils.register({
                "nvim-telescope/telescope-fzf-native.nvim",
                cond = function()
                    return vim.fn.executable("make") > 0 and vim.fn.executable("gcc") > 0
                end,
                build = "make",
                extensions = {
                    fzf = {},
                },
            }),
        },
        cmd = { "Telescope" },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope").extensions.picker_list.picker_list()
                end,
                desc = "Show pickers [Telescope]",
            },
            {
                "<C-P>",
                function()
                    require("telescope.builtin").git_files()
                end,
                desc = "Search files [Telescope]",
            },
            {
                "<A-p>",
                function()
                    require("telescope").extensions["telescope-tabs"].list_tabs()
                end,
                desc = "Search tabs [Telescope]",
            },
            {
                "<A-P>",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "Search buffers [Telescope]",
            },
            {
                "<C-t>",
                function()
                    require("telescope.builtin").current_buffer_tags()
                end,
                desc = "Search buffer tags [Telescope]",
            },
            {
                "<A-t>",
                function()
                    require("telescope.builtin").tags()
                end,
                desc = "Search tags [Telescope]",
            },
            {
                "z=",
                function()
                    require("telescope.builtin").spell_suggest()
                end,
                desc = "Show spelling suggestions [Telescope]",
            },
            {
                "gr",
                function()
                    require("telescope.builtin").lsp_references()
                end,
                desc = "Show LSP references [Telescope]",
            },
        },
        opts = telescope_utils.opts({
            defaults = {
                mappings = {
                    n = {
                        ["q"] = "close",
                        ["<C-c>"] = "close",
                        ["<C-/>"] = "which_key",
                        ["<C-\\>"] = "which_key",
                    },
                    i = {
                        ["<C-/>"] = "which_key",
                        ["<C-\\>"] = "which_key",
                    },
                },
            },
        }),
        config = telescope_utils.config(),
    },
}
