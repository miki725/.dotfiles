return {
    {
        "stefandtw/quickfix-reflector.vim",
        ft = { "qf" },
    },
    {
        "miki725/vim-ripgrep",
        init = function()
            vim.g.rg_command = "rg --vimgrep -S"
            vim.g.rg_highlight = 1
            vim.g.rg_apply_mappings = 1
        end,
        cmd = "Rg",
    },
}
