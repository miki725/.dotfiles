-- highligh search results and make search case insensitive
vim.o.hlsearch = true
-- incremental search
vim.o.incsearch = true
-- insensitive case
vim.o.ignorecase = true
-- allow to disable seach highlight with leader+h
vim.keymap.set({ "n", "v" }, "<leader>h", function()
    vim.o.hlsearch = not vim.o.hlsearch
end, { desc = "Togglie highlighting search results [search]" })

-- use very magic mode by default
-- https://vim.fandom.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
-- nnoremap / /\v
-- vnoremap / /\v
-- cnoremap %s/ %smagic/
-- cnoremap \>s/ \>smagic/
-- nnoremap :g/ :g/\v
-- nnoremap :g// :g//
