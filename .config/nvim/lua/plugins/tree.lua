return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        cond = false,
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        cmd = { "Neotree" },
        keys = {
            {
                "<leader>t",
                function()
                    require("neo-tree.command").execute({ toggle = true, focus = true })
                end,
                desc = "Toggle [NeoTree]",
            },
            {
                "<leader>T",
                function()
                    require("neo-tree.command").execute({ toggle = false, focus = true })
                end,
                desc = "Focus [NeoTree]",
            },
        },
        opts = {
            sources = {
                "filesystem",
                "buffers",
                "git_status",
                "document_symbols",
            },
            open_files_do_not_replace_types = {
                "terminal",
                "Trouble",
                "qf",
                "Outline",
            },
            close_if_last_window = true,
            enable_normal_mode_for_inputs = true,
            window = {
                mappings = {
                    ["<space>"] = "none",
                    ["<bs>"] = "parent",
                    ["u"] = "navigate_up",
                    ["S"] = "none",
                    ["/"] = "none",
                    ["F"] = "fuzzy_finder",
                    ["s"] = "open_split",
                    ["v"] = "open_vsplit",
                    ["<C-t>"] = "open_tabnew",
                    ["<C-v>"] = "open_vsplit",
                    ["<C-s>"] = "open_split",
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["m"] = { "move", config = { show_path = "relative" } },
                    ["c"] = { "copy", config = { show_path = "relative" } },
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- show collapse/open icon
                },
                name = {
                    trailing_slash = true,
                },
                symlink_target = {
                    enabled = true,
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                        deleted = "✖", -- this can only be used in the git_status source
                        renamed = "󰁕", -- this can only be used in the git_status source
                        -- Status type
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                },
            },
            filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = false, -- use autocmd vs OS
                filtered_items = {
                    hide_dotfiles = false,
                    hide_by_name = {
                        ".git",
                        "node_modules",
                    },
                },
            },
            commands = {
                parent = function(state)
                    local utils = require("neo-tree.utils")
                    local renderer = require("neo-tree.ui.renderer")
                    local node = state.tree:get_node()
                    local parent_path, _ = utils.split_path(node:get_id())
                    renderer.focus_node(state, parent_path)
                end,
            },
        },
    },
    {
        "kyazdani42/nvim-tree.lua",
        cond = true,
        commit = "8b8d457",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = {
            "NvimTreeToggle",
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        keys = {
            { "<leader>t", ":NvimTreeToggle<CR>", desc = "Toggle [NvimTree]" },
            { "<leader>T", ":NvimTreeFocus<CR>", desc = "Focus current buffer [NvimTree]" },
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
