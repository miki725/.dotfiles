-- Enable persistent undo so that undo history persists across vim sessions
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undo"
