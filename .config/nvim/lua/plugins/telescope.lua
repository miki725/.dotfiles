local telescope_utils = require("utils.telescope")

local toggle_preview = function(bufnr)
    require("telescope.actions.layout").toggle_preview(bufnr)
end

local select_goto = function(bufnr)
    print("hello")
    require("telescope.actions.set").edit(bufnr, "drop")
end

local is_inside_work_tree = {}

local project_files = function()
    local cwd = vim.fn.getcwd()
    if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
    end

    if is_inside_work_tree[cwd] then
        require("telescope.builtin").git_files()
    else
        require("telescope.builtin").find_files()
    end
end

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
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
            telescope_utils.register({
                "OliverChao/telescope-picker-list.nvim",
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
                "LukasPietzschmann/telescope-tabs",
                extensions = {
                    ["telescope-tabs"] = {},
                },
            }),
            telescope_utils.register({
                "nvim-telescope/telescope-live-grep-args.nvim",
                extensions = {
                    live_grep_args = {
                        mappings = {
                            i = {
                                ["<C-Space>"] = "to_fuzzy_refine",
                            },
                        },
                    },
                },
            }),
            telescope_utils.register({
                "xiyaowong/telescope-emoji.nvim",
                extensions = {
                    emoji = {},
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
                project_files,
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
            {
                "g*",
                function()
                    require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({
                        quote = true,
                        postfix = "",
                    })
                end,
                desc = "Live Grep CWord [Telescope]",
            },
            {
                "<C-F>",
                function()
                    require("telescope").extensions.live_grep_args.live_grep_args()
                end,
                desc = "Live Grep [Telescope]",
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
                        ["<C-p>"] = toggle_preview,
                        ["<CR>"] = select_goto,
                        ["<A-CR>"] = "select_default",
                    },
                    i = {
                        ["<C-/>"] = "which_key",
                        ["<C-\\>"] = "which_key",
                        ["<C-p>"] = toggle_preview,
                        ["<CR>"] = select_goto,
                        ["<A-CR>"] = "select_default",
                    },
                },
            },
        }),
        config = telescope_utils.config(),
    },
}
