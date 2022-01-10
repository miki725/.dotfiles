return function(use)
	use({
		"tanvirtin/monokai.nvim",
		config = function()
			local monokai = require("monokai")
			local palette = monokai.classic
			monokai.setup({
				custom_hlgroups = {
					LspReferenceRead = {
						bg = palette.red,
						fg = palette.white,
					},
					LspReferenceText = {
						bg = palette.red,
						fg = palette.white,
					},
					LspReferenceWrite = {
						bg = palette.red,
						fg = palette.white,
					},
					GitSignsAdd = {
						fg = palette.green,
					},
					GitSignsDelete = {
						fg = palette.pink,
					},
					GitSignsChange = {
						fg = palette.orange,
					},
				},
			})
		end,
	})
end
