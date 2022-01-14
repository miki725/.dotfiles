return function(use)
	use({
		"kdheepak/tabline.nvim",
		config = function()
			require("tabline").setup({
				enable = false,
			})
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			"kdheepak/tabline.nvim",
		},
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {},
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", file_status = true, path = 1 } },
					lualine_x = { "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { _G.cokeline },
					lualine_x = { require("tabline").tabline_tabs },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = {},
			})
			vim.cmd("au OptionSet showtabline :set showtabline=1")
		end,
	})
	use({
		"noib3/nvim-cokeline",
		requires = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			local get_hex = require("cokeline/utils").get_hex

			require("cokeline").setup({
				show_if_buffers_are_at_least = 1,

				buffers = {
					filter_valid = function(buffer)
						for _, buf in pairs(vim.fn.tabpagebuflist()) do
							if buf == buffer.number then
								return true
							end
						end
						return false
					end,
				},

				default_hl = {
					focused = {
						fg = get_hex("Normal", "fg"),
						bg = get_hex("ColorColumn", "bg"),
					},
					unfocused = {
						fg = get_hex("Comment", "fg"),
						bg = get_hex("ColorColumn", "bg"),
					},
				},

				rendering = {
					left_sidebar = {
						filetype = "NvimTree",
						components = {
							{
								text = " NvimTree",
								hl = {
									fg = get_hex("ColorColumn", "fg"),
									bg = get_hex("ColorColumn", "bg"),
									style = "bold",
								},
							},
						},
					},
				},

				components = {
					{
						text = function(buffer)
							return (buffer.index ~= 1) and "▏" or ""
						end,
					},
					{
						text = "  ",
					},
					{
						text = function(buffer)
							return buffer.devicon.icon
						end,
						hl = {
							fg = function(buffer)
								return buffer.devicon.color
							end,
						},
					},
					{
						text = " ",
					},
					{
						text = function(buffer)
							return buffer.filename .. "  "
						end,
						hl = {
							style = function(buffer)
								return buffer.is_focused and "bold" or nil
							end,
						},
					},
					{
						text = "",
						delete_buffer_on_left_click = true,
					},
					{
						text = "  ",
					},
				},
			})
		end,
	})
end
