return function(use)
    use({
        "haya14busa/incsearch-fuzzy.vim",
        config = function()
            vim.cmd([[
                map z/ <Plug>(incsearch-fuzzy-/)
                map z? <Plug>(incsearch-fuzzy-?)
                map zg/ <Plug>(incsearch-fuzzy-stay)
            ]])
        end,
    })
    use({
        "haya14busa/incsearch.vim",
        config = function()
            vim.cmd([[
                map /  <Plug>(incsearch-forward)
                map ?  <Plug>(incsearch-backward)
                map g/ <Plug>(incsearch-stay)
            ]])
        end,
    })
end
