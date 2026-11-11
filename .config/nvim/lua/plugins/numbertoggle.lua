return {
    -- relative line numbers
    {
        "jeffkreeftmeijer/vim-numbertoggle",
        config = function()
            Snacks.toggle
                .new({
                    id = "relativenumber",
                    name = "Relative Numbers [NumberToggle]",
                    get = function()
                        return vim.o.relativenumber
                    end,
                    set = function(state)
                        vim.o.relativenumber = state
                    end,
                })
                :map("<leader>tn")
        end,
    },
}
