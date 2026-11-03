-- Enable persistent undo so that undo history persists across vim sessions
-- except for gopass secrets
vim.o.undofile = not require("gopass").active
vim.o.undodir = os.getenv("HOME") .. "/.vim/undo"
