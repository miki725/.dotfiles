vim.keymap.set({ "v" }, "<leader>s", function()
    return ":sort<cr>"
end, { expr = true, desc = "Sort selection [sort]" })
