return {
    {
        "junegunn/goyo.vim",
        cmd = {
            "Goyo",
        },
        init = function()
            vim.g.goyo_width = 83
            vim.g.goyo_linenr = 0
        end,
    },
    {
        "junegunn/limelight.vim",
        cmd = {
            "Limelight",
        },
        init = function()
            vim.cmd([[
                autocmd! User GoyoEnter Limelight
                autocmd! User GoyoLeave Limelight!
            ]])
        end,
    },
}
