return function(use)
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					use_languagetree = true,
					disable = {},
				},
				indent = {
					enable = false,
					disable = {},
				},
				refactor = {
					highlight_definitions = {
						enable = true,
					},
				},
				rainbow = {
					enable = true,
					extended_mode = true,
				},
				ensure_installed = "maintained",
			})
		end,
	})
	use({ "nvim-treesitter/nvim-treesitter-refactor" })
end
