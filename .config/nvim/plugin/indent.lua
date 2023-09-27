-- default tab config - customized with autocmd below per file type
-- http://vimcasts.org/episodes/tabs-and-spaces/

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true -- use spaces for indents

-- preserve existing indent for new lines
vim.o.autoindent = true
vim.o.smartindent = true

-- allow backspace to remove indent, etc
vim.opt.backspace = { "indent", "eol", "start" }
