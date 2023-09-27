vim.o.splitright = true
vim.o.splitbelow = true
--
-- shortcut for editing files in same directory as current file
-- vim.keymap does not automatically expand %%
vim.cmd([[
map <leader>ew :edit %%
map <leader>es :split %%
map <leader>ev :vsplit %%
map <leader>et :tabedit %%
]])
