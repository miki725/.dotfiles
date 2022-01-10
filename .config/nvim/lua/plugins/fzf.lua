return function(use)
	use({
		"ibhagwan/fzf-lua",
		requires = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			vim.api.nvim_set_keymap(
				"n",
				"<c-P>",
				"<cmd>lua require('fzf-lua').git_files()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<c-B>",
				"<cmd>lua require('fzf-lua').buffers()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<c-t>",
				"<cmd>lua require('fzf-lua').btags()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<a-t>",
				"<cmd>lua require('fzf-lua').tags()<CR>",
				{ noremap = true, silent = true }
			)

			vim.api.nvim_set_keymap(
				"n",
				"gr",
				"<cmd>lua require('fzf-lua').lsp_references()<CR>",
				{ noremap = true, silent = true }
			)

			require("fzf-lua").setup({
				lsp = {
					-- make lsp requests synchronous so they work with null-ls
					async_or_timeout = 3000,
				},
			})
		end,
	})
end
