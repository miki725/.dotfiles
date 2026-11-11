local snacks_utils = require("utils.snacks")

local is_inside_work_tree = {}

local project_files = function()
    local cwd = vim.fn.getcwd()
    if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
    end

    if is_inside_work_tree[cwd] then
        Snacks.picker.git_files()
    else
        Snacks.picker.files()
    end
end

-- keep telescope muscle memory in snacks pickers
local picker_keys = {
    ["<CR>"] = { "drop", mode = { "n", "i" } },
    ["<A-CR>"] = { "confirm", mode = { "n", "i" } },
    ["<C-p>"] = { "toggle_preview", mode = { "n", "i" } },
    ["<C-c>"] = { "cancel", mode = { "n", "i" } },
    ["<C-/>"] = { "toggle_help_input", mode = { "n", "i" } },
    ["<C-\\>"] = { "toggle_help_input", mode = { "n", "i" } },
    ["<C-x>"] = { "edit_split", mode = { "n", "i" } },
    ["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
    ["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
    ["<C-j>"] = { "history_forward", mode = "i" },
    ["<C-k>"] = { "history_back", mode = "i" },
}

return {
    snacks_utils.register({
        -- TODO switch back to folke/snacks.nvim once tags picker streams tag files
        -- https://github.com/folke/snacks.nvim/pull/2994
        "miki725/snacks.nvim",
        branch = "ms/tags-stream",
        priority = 1000,
        lazy = false,
        opts = snacks_utils.opts({
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
            notifier = { enabled = true, timeout = 5000 },
            bigfile = { enabled = true },
            input = { enabled = true },
            animate = { enabled = false },
            scroll = { enabled = false },
            lazygit = {},
            -- replaces telescope. plugins add their own pickers with utils.snacks.register()
            picker = {
                ui_select = true,
                layout = {
                    preset = function()
                        return vim.o.columns >= 120 and "telescope" or "vertical"
                    end,
                },
                win = {
                    input = { keys = picker_keys },
                    list = { keys = picker_keys },
                },
                sources = {
                    -- close with <C-d>. their default <c-x> close would shadow split from picker_keys
                    buffers = {
                        win = {
                            input = {
                                keys = {
                                    ["<C-d>"] = { "bufdelete", mode = { "n", "i" } },
                                    ["<C-x>"] = picker_keys["<C-x>"],
                                },
                            },
                        },
                    },
                    tabs = {
                        win = {
                            input = {
                                keys = {
                                    ["<C-d>"] = { "tab_close", mode = { "n", "i" } },
                                    ["<C-x>"] = picker_keys["<C-x>"],
                                },
                            },
                        },
                    },
                    grep = {
                        win = {
                            input = { keys = { ["<C-Space>"] = { "toggle_live", mode = { "n", "i" } } } },
                        },
                    },
                    undo = {
                        layout = { preset = "vertical" },
                    },
                },
            },
        }),
        keys = {
            {
                "<leader>ff",
                function()
                    Snacks.picker.pickers()
                end,
                desc = "Picker: Show pickers",
            },
            {
                "<C-P>",
                project_files,
                desc = "Picker: Search files",
            },
            {
                "<A-f>",
                function()
                    Snacks.picker.files()
                end,
                desc = "Picker: Search fs files",
            },
            {
                "<A-P>",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Picker: Search buffers",
            },
            {
                "z=",
                function()
                    Snacks.picker.spelling()
                end,
                desc = "Picker: Show spelling suggestions",
            },
            {
                "grr",
                function()
                    Snacks.picker.lsp_references()
                end,
                desc = "Picker: Show LSP references",
            },
            {
                "g*",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "Picker: Grep CWord",
            },
            {
                "<C-F>",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Picker: Live Grep",
            },
            {
                "<leader>u",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Picker: Undo history",
            },
            {
                "<leader>lg",
                function()
                    Snacks.lazygit()
                end,
                desc = "Lazygit [Snacks.lazygit]",
            },
            {
                "<leader>z",
                function()
                    Snacks.zen()
                end,
                desc = "Toggle Zen Mode [Snacks.zen]",
            },
            {
                "<leader>n",
                function()
                    Snacks.notifier.show_history()
                end,
                desc = "Notification History [Snacks.notifier]",
            },
        },
    }),
    snacks_utils.register({
        "miki725/snacks-tabs.nvim",
        keys = {
            {
                "<A-p>",
                function()
                    Snacks.picker.tabs()
                end,
                desc = "Picker: Search tabs",
            },
        },
        pickers = {
            tabs = snacks_utils.lazy_source(function()
                return require("snacks-tabs").source
            end),
        },
    }),
}
