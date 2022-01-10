vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_echo_preview_url = 1

return function(use)
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
	})
end
