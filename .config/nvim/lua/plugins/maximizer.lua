vim.cmd([[
nnoremap <C-\> :MaximizerToggle<CR>
vnoremap <C-\> :MaximizerToggle<CR>gv
inoremap <C-\> <C-o>:MaximizerToggle<CR>
]])

return function(use)
	use({
		"szw/vim-maximizer",
		cmd = "MaximizerToggle",
	})
end
