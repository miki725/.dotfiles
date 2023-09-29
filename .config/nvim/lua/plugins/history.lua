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
        "dawsers/telescope-file-history.nvim",
        event = { "BufWritePost" },
        main = "file_history",
        dev = true,
        opts = {
            backup_dir = vim.fn.stdpath("cache") .. "/file-history-git",
        },
    },
}
