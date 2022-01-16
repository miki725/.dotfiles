return function(use)
	use({
		"feline-nvim/feline.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			local vi_mode_utils = require("feline.providers.vi_mode")

			local comps = {

				prefix = {
					provider = "  ",
					hl = function()
						return {
							bg = vi_mode_utils.get_mode_color(),
						}
					end,
				},

				vi_mode = {
					provider = "vi_mode",
					hl = function()
						return {
							name = vi_mode_utils.get_mode_highlight_name(),
							fg = "white",
							bg = vi_mode_utils.get_mode_color(),
							style = "bold",
						}
					end,
				},

				file_info = {
					provider = "file_info",
					hl = {
						fg = "white",
						bg = "oceanblue",
						style = "bold",
					},
					left_sep = {
						"slant_left_2",
						{ str = " ", hl = { bg = "oceanblue", fg = "NONE" } },
					},
					right_sep = {
						{ str = " ", hl = { bg = "oceanblue", fg = "NONE" } },
						"slant_right_2",
						" ",
					},
				},

				file_info_muted = {
					provider = "file_info",
					hl = {
						fg = "white",
						bg = "oceanblue",
						style = "bold",
					},
					left_sep = {
						"slant_left_2",
						{ str = " ", hl = { bg = "oceanblue", fg = "NONE" } },
					},
					right_sep = {
						{ str = " ", hl = { bg = "oceanblue", fg = "NONE" } },
						"slant_right_2",
						" ",
					},
				},

				file_size = {
					provider = "file_size",
					right_sep = {
						" ",
						{
							str = "slant_left_2_thin",
							hl = {
								fg = "fg",
								bg = "bg",
							},
						},
					},
				},

				position = {
					provider = "position",
					left_sep = " ",
					right_sep = {
						" ",
						{
							str = "slant_right_2_thin",
							hl = {
								fg = "fg",
								bg = "bg",
							},
						},
					},
				},

				diag = {
					err = {
						provider = "diagnostic_errors",
						hl = { fg = "red" },
					},
					warn = {
						provider = "diagnostic_warnings",
						hl = { fg = "yellow" },
					},
					hint = {
						provider = "diagnostic_hints",
						hl = { fg = "cyan" },
					},
					info = {
						provider = "diagnostic_info",
						hl = { fg = "skyblue" },
					},
				},

				git_branch = {
					provider = "git_branch",
					hl = {
						fg = "white",
						bg = "black",
						style = "bold",
					},
					right_sep = {
						str = " ",
						hl = {
							fg = "NONE",
							bg = "black",
						},
					},
				},

				git_diff = {
					add = {
						provider = "git_diff_added",
						hl = {
							fg = "green",
							bg = "black",
						},
					},
					change = {
						provider = "git_diff_changed",
						hl = {
							fg = "orange",
							bg = "black",
						},
					},
					remove = {
						provider = "git_diff_removed",
						hl = {
							fg = "red",
							bg = "black",
						},
						right_sep = {
							str = " ",
							hl = {
								fg = "NONE",
								bg = "black",
							},
						},
					},
				},

				progress = {
					provider = "line_percentage",
					hl = {
						style = "bold",
					},
					left_sep = "  ",
					right_sep = " ",
				},

				scroll = {
					provider = "scroll_bar",
					hl = {
						fg = "skyblue",
						style = "bold",
					},
				},
			}

			require("feline").setup({
				components = {
					active = {
						{
							comps.prefix,
							comps.vi_mode,
							comps.file_info,
							comps.file_size,
							comps.position,
							comps.diag.err,
							comps.diag.warn,
							comps.diag.hint,
							comps.diag.error,
						},
						{
							comps.git_branch,
							comps.git_diff.add,
							comps.git_diff.change,
							comps.git_diff.remove,
						},
					},
					inactive = {
						{
							comps.file_info_muted,
							{},
						},
					},
				},
			})
		end,
	})
end
