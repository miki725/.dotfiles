return {
    -- relative line numbers
    {
        "jeffkreeftmeijer/vim-numbertoggle",
        init = function()
            vim.keymap.set("n", "<leader>tn", function()
                vim.o.relativenumber = not vim.o.relativenumber
            end, { desc = "Toggle Relative Numbers [NumberToggle]" })
        end,
    },
}
