local telescope_utils = require("utils.telescope")

return {
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", "gc", desc = "Comment Lines [Comment]" },
            { "gb", "gb", desc = "Comment Block [Comment]" },
            { "gc", "gc", desc = "Comment Lines [Comment]", mode = "v" },
            { "gb", "gb", desc = "Comment Block [Comment]", mode = "v" },
        },
        config = function()
            require("Comment").setup({
                padding = true,
                sticky = true,
                ignore = "^$",
                toggler = {
                    line = "gcc",
                    block = "gbc",
                },
                opleader = {
                    line = "gc",
                    block = "gb",
                },
                extra = {
                    above = "gcO",
                    below = "gco",
                    eol = "gcA",
                },
                mappings = {
                    basic = true,
                    extra = true,
                    extended = false,
                },
                pre_hook = nil,
                post_hook = nil,
            })
        end,
    },
    telescope_utils.register({
        "folke/todo-comments.nvim",
        cond = function()
            return vim.fn.executable("fd") > 0
        end,
        cmd = {
            "TodoTrouble",
            "TodoTelescope",
            "TodoQuickFix",
        },
        config = true,
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment [TodoComments]",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment [TodoComments]",
            },
        },
        extensions = {
            ["todo-comments"] = {},
        },
    }),
}
