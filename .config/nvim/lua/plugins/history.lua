local telescope_utils = require("utils.telescope")

return {
    {
        "kevinhwang91/nvim-fundo",
        dependencies = { "kevinhwang91/promise-async" },
        event = { "BufReadPost" },
        build = function()
            require("fundo").install()
        end,
        opts = {
            archives_dir = vim.fn.stdpath("cache") .. "/fundo",
        },
    },
    telescope_utils.register({
        "debugloop/telescope-undo.nvim",
        keys = {
            {
                "<leader>u",
                function()
                    require("telescope").extensions.undo.undo()
                end,
            },
        },
        extensions = {
            undo = {
                layout_strategy = "vertical",
                layout_config = {
                    preview_height = 0.8,
                },
            },
        },
    }),
    telescope_utils.register({
        "dawsers/telescope-file-history.nvim",
        event = { "BufWritePost" },
        main = "file_history",
        opts = {
            backup_dir = vim.fn.stdpath("cache") .. "/file-history-git",
        },
    }),
}
