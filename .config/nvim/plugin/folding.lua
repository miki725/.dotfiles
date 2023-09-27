-- http://vimcasts.org/episodes/how-to-fold/

-- vim.o.foldmethod = "syntax"

vim.keymap.set("n", "<space>", "za", { desc = "toggle fold" })

vim.o.foldlevel = 1

-- so that paragraph jumps do not open folded blocks
vim.opt.foldopen:remove("block")
