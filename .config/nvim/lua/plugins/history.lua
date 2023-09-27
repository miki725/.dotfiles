return {
    {
        "dawsers/telescope-file-history.nvim",
        event = { "BufWritePost" },
        main = "file_history",
        dev = true,
        opts = {
            backup_dir = "~/.local/state/nvim/file-history-git",
        },
    },
}
