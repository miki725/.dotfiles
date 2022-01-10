return function(use)
	use({
		"phaazon/hop.nvim",
		config = function()
			require("hop").setup({
				keys = "etovxqpdygfblzhckisuran",
			})
			local map = vim.api.nvim_set_keymap
			map(
				"n",
				"<leader>f",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
				{}
			)
			map(
				"n",
				"<leader>F",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
				{}
			)
			map(
				"o",
				"<leader>f",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
				{}
			)
			map(
				"o",
				"<leader>F",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
				{}
			)
			map(
				"",
				"<leader>t",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
				{}
			)
			map(
				"",
				"<leader>T",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
				{}
			)
		end,
	})
end
