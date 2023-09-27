-- folding needs to switching to nvim_treesitter
-- only after treesitter loads
-- otherwise either the syntax is not highlighted
-- until :e or folding does not work
-- https://www.reddit.com/r/neovim/comments/njew3z/treesitter_code_folding/
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = false -- Disable folding at startup.
