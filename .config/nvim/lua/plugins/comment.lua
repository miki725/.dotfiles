local snacks_utils = require("utils.snacks")

return {
    snacks_utils.register({
        "folke/todo-comments.nvim",
        cond = function()
            return vim.fn.executable("fd") > 0
        end,
        cmd = {
            "TodoTrouble",
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
        pickers = {
            todo_comments = snacks_utils.lazy_source(function()
                return require("todo-comments.snacks").source
            end),
        },
    }),
}
