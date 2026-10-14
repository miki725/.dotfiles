-- runtime ftplugin/markdown.vim loads after this file and would reset
-- et/ts/sts/sw to 4 unless its recommended style is disabled
vim.g.markdown_recommended_style = 0

vim.opt_local.expandtab = true
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.textwidth = 79
vim.opt_local.colorcolumn = { 80 }
vim.opt_local.spell = true

-- align new lines with list item text (treesitter indent keeps the bullet's level)
-- only reindent on new lines, not when typing ":" or "#"
vim.opt_local.indentexpr = "v:lua.require'utils.markdown'.indent()"
vim.opt_local.indentkeys = "!^F,o,O"
