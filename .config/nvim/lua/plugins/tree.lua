return {
    {
        "kyazdani42/nvim-tree.lua",
        commit = "8b8d457",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
        cmd = {
            "NvimTreeToggle",
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        keys = {
            { "<leader>t", ":NvimTreeToggle<CR>" },
            { "<leader>T", ":NvimTreeFocus<CR>" },
        },
        opts = {
            disable_netrw = true,
            hijack_netrw = true,
            open_on_tab = false,
            hijack_cursor = false,
            update_cwd = false,
            hijack_directories = {
                enable = false,
                auto_open = true,
            },
            diagnostics = {
                enable = false,
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                },
            },
            update_focused_file = {
                enable = true,
                update_cwd = true,
                ignore_list = {},
            },
            system_open = {
                cmd = nil,
                args = {},
            },
            filters = {
                dotfiles = false,
                custom = {},
            },
            git = {
                enable = true,
                ignore = true,
                timeout = 500,
            },
            view = {
                width = 30,
                side = "left",
                adaptive_size = false,
                number = false,
                relativenumber = false,
                signcolumn = "yes",
            },
            trash = {
                cmd = "trash",
                require_confirm = true,
            },
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                },
            },
        },
    },
}
