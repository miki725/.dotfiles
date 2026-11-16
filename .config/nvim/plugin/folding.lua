-- http://vimcasts.org/episodes/how-to-fold/

-- vim.o.foldmethod = "syntax"

vim.keymap.set("n", "<space>", "za", { desc = "Toggle fold [folding]" })

-- start with all folds open so the first <space> (which enables folding) only closes
-- the fold under cursor instead of everything below level 1. zM folds all, zR unfolds all
vim.o.foldlevel = 99

-- so that paragraph jumps do not open folded blocks
vim.opt.foldopen:remove("block")
