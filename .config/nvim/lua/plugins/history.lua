local snacks_utils = require("utils.snacks")

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
    -- only history of the current file. backups are what it records
    snacks_utils.register({
        -- TODO switch back to dawsers/file-history.nvim once it registers snacks sources
        -- https://github.com/dawsers/file-history.nvim/pull/7
        "miki725/file-history.nvim",
        branch = "ms/snacks-sources",
        -- used but not documented by the plugin
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufWritePost" },
        cmd = { "FileHistory" },
        opts = {
            backup_dir = vim.fn.stdpath("cache") .. "/file-history-git",
        },
        config = function(_, opts)
            local file_history = require("file_history")
            file_history.setup(opts)
            -- plugin command requires a subcommand. only history is used
            vim.api.nvim_create_user_command("FileHistory", file_history.history, { desc = "File history" })
        end,
        pickers = {
            -- plugin registers its source on setup which is lazy
            file_history = snacks_utils.lazy_source(function()
                require("file_history")
                return require("snacks.picker").sources.file_history
            end),
        },
    }),
}
