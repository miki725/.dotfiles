return {
    {
        "nvim-neo-tree/neo-tree.nvim",
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
                width = 30,
                mappings = {
                    ["<space>"] = "none",
                    ["<bs>"] = "none",
                    ["h"] = "parent",
                    ["<left>"] = "parent",
                    ["S"] = "none",
                    ["/"] = "none",
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
                window = {
                    mappings = {
                        ["u"] = "navigate_up",
                        ["F"] = "fuzzy_finder",
                    },
                },
            },
            buffers = {
                window = {
                    mappings = {
                        ["h"] = "parent",
                        ["<left>"] = "parent",
                    },
                },
            },
            git_status = {
                window = {
                    mappings = {},
                },
            },
            commands = {
                parent = function(state)
                    local node = state.tree:get_node()
                    require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                end,
            },
        },
    },
}
