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
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        init = function()
            vim.api.nvim_create_user_command("UndoTree", function()
                require("undotree").toggle()
            end, {})
        end,
        cmd = { "UndoTree" },
        keys = {
            {
                "<leader>u",
                function()
                    require("undotree").toggle()
                end,
            },
        },
    },
    telescope_utils.register({
        "dawsers/telescope-file-history.nvim",
        event = { "BufWritePost" },
        main = "file_history",
        opts = {
            backup_dir = vim.fn.stdpath("cache") .. "/file-history-git",
        },
    }),
}
