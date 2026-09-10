local telescope_utils = require("utils.telescope")

return {
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
