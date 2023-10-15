return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "dawsers/telescope-file-history.nvim", -- history.lua
            {
                "LukasPietzschmann/telescope-tabs",
                keys = {
                    {
                        "<A-p>",
                        function()
                            require("telescope-tabs").list_tabs()
                        end,
                        desc = "Search tabs [Telescope]",
                    },
                },
                config = function(_, opts)
                    require("telescope-tabs").setup(opts)
                    require("telescope").load_extension("telescope-tabs")
                end,
            },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                cond = function()
                    return vim.fn.executable("make") > 0 and vim.fn.executable("gcc") > 0
                end,
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
        cmd = { "Telescope" },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").builtin()
                end,
                desc = "Show builtins [Telescope]",
            },
            {
                "<C-P>",
                function()
                    require("telescope.builtin").git_files()
                end,
                desc = "Search files [Telescope]",
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
        opts = {
            defaults = {
                mappings = {
                    n = {
                        ["q"] = "close",
                        ["<C-/>"] = "which_key",
                        ["<C-\\>"] = "which_key",
                    },
                    i = {
                        ["<C-/>"] = "which_key",
                        ["<C-\\>"] = "which_key",
                    },
                },
            },
        },
    },
}
