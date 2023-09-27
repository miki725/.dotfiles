-- show hidden cars
vim.o.list = true
-- show all characters
vim.o.conceallevel = 0
-- specify how hidden chars are represented
-- http://vimcasts.org/episodes/show-invisibles/
vim.opt_global.listchars = { tab = "▸ ", eol = "¬" }
