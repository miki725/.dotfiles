return function(use)
	use({
		"phaazon/hop.nvim",
		keys = {
			{ "n", "<leader>hf" },
			{ "n", "<leader>hF" },
			{ "n", "<leader>ht" },
			{ "n", "<leader>hT" },
		},
		config = function()
			require("hop").setup({
				keys = "etovxqpdygfblzhckisuran",
			})
			local map = vim.api.nvim_set_keymap
			map(
				"n",
				"<leader>hf",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
				{}
			)
			map(
				"n",
				"<leader>hF",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
				{}
			)
			map(
				"o",
				"<leader>hf",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
				{}
			)
			map(
				"o",
				"<leader>hF",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
				{}
			)
			map(
				"",
				"<leader>ht",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
				{}
			)
			map(
				"",
				"<leader>hT",
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
				{}
			)
		end,
	})
end
