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

-- copy permalink to clipboard instead of opening the browser (gitlinker behaviour)
local git_link = function(opts)
    Snacks.gitbrowse({
        what = "permalink",
        notify = false,
        open = function(url)
            if opts.strip_lines then
                url = url:gsub("#.*$", "")
            end
            vim.fn.setreg("*", url)
            vim.fn.setreg("+", url)
            Snacks.notify(url, { title = "Git Link" })
        end,
    })
end

-- neo-tree style yank of explorer node path into both clipboards
local explorer_yank = function(modifier)
    return function(_, item)
        if not item then
            return
        end
        local value = vim.fn.fnamemodify(item.file, modifier)
        vim.fn.setreg("*", value)
        vim.fn.setreg("+", value)
        print(value)
    end
end

-- reveal current file and focus explorer, opening it if needed
local explorer_focus = function()
    local picker = Snacks.explorer.reveal()
    if picker then
        picker:focus()
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

-- replaces goyo + limelight
-- passed per call instead of opts.zen so Snacks.zen.zoom() keeps normal window look
local zen_opts = {
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
}

return {
    snacks_utils.register({
        -- TODO switch back to folke/snacks.nvim once these are merged. ms/miki725 merges all of them
        -- https://github.com/folke/snacks.nvim/pull/2994 tags picker streams tag files
        -- https://github.com/folke/snacks.nvim/pull/2998 help picker preview matches case
        -- https://github.com/folke/snacks.nvim/pull/2999 tags picker searches with 'magic' off
        "miki725/snacks.nvim",
        branch = "ms/miki725",
        priority = 1000,
        lazy = false,
        init = function()
            -- close explorer when it would be the last window (neo-tree close_if_last_window)
            vim.api.nvim_create_autocmd("QuitPre", {
                callback = function()
                    local current = vim.api.nvim_get_current_win()
                    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                        local is_float = vim.api.nvim_win_get_config(win).relative ~= ""
                        if win ~= current and not is_float and not vim.w[win].snacks_layout then
                            return
                        end
                    end
                    for _, picker in ipairs(Snacks.picker.get({ source = "explorer" })) do
                        picker:close()
                    end
                    -- picker:close() removes windows async which is too late for :q
                    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                        if vim.w[win].snacks_layout then
                            pcall(vim.api.nvim_win_close, win, true)
                        end
                    end
                end,
            })
        end,
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
            -- ii/ai textobjects and [i/]i jumps on treesitter or indent scope
            scope = { enabled = true },
            -- inline images in markdown via kitty graphics (ghostty, tmux needs allow-passthrough)
            image = { enabled = true },
            -- lsp-only, no treesitter/regex fallback (illuminate handles non-lsp files like markdown)
            words = { enabled = false },
            notifier = { enabled = true, timeout = 5000 },
            bigfile = { enabled = true },
            input = { enabled = true },
            animate = { enabled = false },
            scroll = { enabled = false },
            lazygit = {},
            -- dirbuf handles directory buffers
            explorer = { replace_netrw = false },
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
                    -- replaces neo-tree
                    explorer = {
                        hidden = true,
                        exclude = { "/.git", "/node_modules" },
                        layout = {
                            -- explorer default preview=false drops sidebar's preview="main"
                            -- so toggled preview would split inside the tree instead of the editor
                            preview = { enabled = false, main = true },
                            layout = { width = 30, min_width = 30 },
                        },
                        icons = {
                            git = {
                                staged = "",
                                added = "󰄱",
                                modified = "󰄱",
                                deleted = "✖",
                                renamed = "󰁕",
                                untracked = "",
                                ignored = "",
                                unmerged = "",
                            },
                        },
                        -- trailing slash on directories.
                        -- dotfiles (and anything under a dot dir) are dimmed same as git ignored
                        -- which is misleading in ~ dotfiles repo so only dim ignored like neo-tree
                        format = function(item, picker)
                            local ret = Snacks.picker.format.file(item, picker)
                            for _, part in ipairs(ret) do
                                if part.field == "file" then
                                    if item.dir then
                                        part[1] = part[1]:gsub("/?$", "/")
                                    end
                                    if part[2] == "SnacksPickerPathHidden" then
                                        part[2] = item.dir and "SnacksPickerDirectory" or "SnacksPickerFile"
                                    end
                                    break
                                end
                            end
                            return ret
                        end,
                        actions = {
                            -- move cursor to parent dir without collapsing it
                            explorer_parent = function(picker, item)
                                if item and item.parent then
                                    require("snacks.explorer.actions").update(picker, { target = item.parent.file })
                                end
                            end,
                            yank_relative_path = explorer_yank(":."),
                            yank_absolute_path = explorer_yank(":p"),
                            yank_filename = explorer_yank(":t"),
                            yank_folder = explorer_yank(":p:h"),
                        },
                        win = {
                            list = {
                                keys = {
                                    -- global picker_keys "drop" would open dirs instead of expanding them
                                    ["<CR>"] = "confirm",
                                    -- no preview so restore list scrolling
                                    ["<C-d>"] = "list_scroll_down",
                                    ["<C-u>"] = "list_scroll_up",
                                    ["<BS>"] = false,
                                    ["h"] = "explorer_parent",
                                    ["<Left>"] = "explorer_parent",
                                    ["l"] = "confirm",
                                    ["<Right>"] = "confirm",
                                    ["s"] = "edit_split",
                                    ["<C-s>"] = "edit_split",
                                    ["v"] = "edit_vsplit",
                                    ["<C-v>"] = "edit_vsplit",
                                    ["<C-t>"] = "tab",
                                    ["u"] = "explorer_up",
                                    ["R"] = "explorer_update",
                                    ["F"] = "toggle_focus",
                                    ["<leader>cf"] = "yank_relative_path",
                                    ["<leader>cF"] = "yank_absolute_path",
                                    ["<leader>ct"] = "yank_filename",
                                    ["<leader>cT"] = "yank_folder",
                                },
                            },
                        },
                    },
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
                "<leader>t",
                function()
                    Snacks.explorer()
                end,
                desc = "Toggle [Snacks.explorer]",
            },
            {
                "<leader>T",
                explorer_focus,
                desc = "Focus [Snacks.explorer]",
            },
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
                    Snacks.zen(zen_opts)
                end,
                desc = "Toggle Zen Mode [Snacks.zen]",
            },
            {
                "<C-\\>",
                function()
                    Snacks.zen.zoom()
                end,
                mode = { "n", "v" },
                desc = "Maximize Buffer [Snacks.zen.zoom]",
            },
            {
                "<leader>gy",
                function()
                    git_link({})
                end,
                mode = { "n", "v" },
                desc = "Copy line/selection git link [Snacks.gitbrowse]",
            },
            {
                "<leader>gY",
                function()
                    git_link({ strip_lines = true })
                end,
                mode = { "n", "v" },
                desc = "Copy file git link [Snacks.gitbrowse]",
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
