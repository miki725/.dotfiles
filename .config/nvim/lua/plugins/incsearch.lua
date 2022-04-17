return function(use)
    use({
        "haya14busa/incsearch-fuzzy.vim",
        requires = {
            "haya14busa/incsearch.vim",
        },
        keys = {
            { "n", "z/" },
            { "n", "z?" },
            { "v", "zg/" },
        },
        config = function()
            vim.cmd([[
                map z/ <Plug>(incsearch-fuzzy-/)
                map z? <Plug>(incsearch-fuzzy-?)
                map zg/ <Plug>(incsearch-fuzzy-stay)
            ]])
        end,
    })
end
