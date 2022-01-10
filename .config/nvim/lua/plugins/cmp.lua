vim.cmd([[
set completeopt=menu,menuone,noselect
]])

return function(use)
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"L3MON4D3/LuaSnip",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"onsails/lspkind-nvim",
			-- "quangnguyen30192/cmp-nvim-tags", -- pretty slow
			"ray-x/cmp-treesitter",
		},
		config = function()
			local cmp = require("cmp")

			-- shows LSP kind for the autocomplete icon+text
			local lspkind = require("lspkind")
			lspkind.init()

			cmp.setup({

				formatting = {
					format = lspkind.cmp_format({
						with_text = true, -- do not show text alongside icons
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						menu = {
							buffer = "(Buffer)",
							calc = "(Calc)",
							emoji = "(Emoji)",
							gh_issues = "(Issues)",
							luasnip = "(Snippet)",
							nvim_lsp = "(LSP)",
							path = "(Path)",
							treesitter = "(TS)",
							spell = "(Spell)",
						},
					}),
				},

				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},

				mapping = {
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
					["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
					["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				},

				sources = cmp.config.sources({
					{
						name = "path",
						priority_weight = 110,
					},
					{
						name = "nvim_lsp",
						priority_weight = 100,
					},
					{
						name = "treesitter",
						priority_weight = 90,
					},
					{
						name = "buffer",
						priority_weight = 80,
					},
					{
						name = "spell",
						priority_weight = 70,
						max_item_count = 5,
					},
					-- { name = "tags" }, -- pretty slow
				}),
			})

			-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

			-- Setup lspconfig.
			-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
			-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
			-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
			-- capabilities = capabilities
			-- }
		end,
	})
end
