-- show LSP floating window with border
local border = {
	{ "╭", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╮", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "╯", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╰", "FloatBorder" },
	{ "│", "FloatBorder" },
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- show symbolc in the gutter for error types
local signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return function(use)
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"jose-elias-alvarez/null-ls.nvim",
			"folke/trouble.nvim",
			"folke/lsp-colors.nvim",
			"weilbith/nvim-code-action-menu",
			"folke/lua-dev.nvim",
		},
		config = function()
			-- shows all violations in a project
			require("trouble").setup({})

			local nvim_lsp = require("lspconfig")
			local null_ls = require("null-ls")
			local luadev = require("lua-dev")

			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				float = {
					source = "always", -- Or "if_many"
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			local disable_formatting = function(client)
				for _, filetype in pairs(client.config.filetypes) do
					-- attempt to find null-ls formatting source for same filetype
					-- in which case disable the native lsp client formatting
					for _, source in pairs(null_ls.get_sources()) do
						if source.methods[null_ls.methods.FORMATTING] and source.filetypes[filetype] then
							client.resolved_capabilities.document_formatting = false
							client.resolved_capabilities.document_range_formatting = false
							return
						end
					end
				end
			end

			-- Use an on_attach function to only map the following keys
			-- after the language server attaches to the current buffer
			local on_attach = function(client, bufnr)
				-- Mappings.
				local opts = { noremap = true, silent = true }
				local function nmap(...)
					vim.api.nvim_buf_set_keymap(bufnr, ...)
				end

				-- See `:help vim.lsp.*` for documentation on any of the below functions
				nmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
				nmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
				nmap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
				nmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
				-- moved to fzf as it allows to easily open in new tab/split/etc
				-- nmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
				nmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				nmap("n", "L", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
				nmap("n", "<leader>qf", ":CodeActionMenu<CR>", opts)
				nmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
				nmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
				nmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

				vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
				vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
				vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
				vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
				vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
				vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
				vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
				vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
				vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
				vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
				vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
				vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

				-- delay before float appears or autocomplete shows up
				vim.o.updatetime = 250
				vim.cmd("autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focusable=false})")

				if client.resolved_capabilities.document_highlight then
					vim.cmd([[
                     augroup lsp_document_highlight
                       autocmd! * <buffer>
                       autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                       autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                     augroup END
                   ]])
				end

				if client.resolved_capabilities.document_formatting then
					vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
				end
			end

			local servers = {
				"tsserver",
				"terraformls",
			}

			for _, lsp in ipairs(servers) do
				nvim_lsp[lsp].setup({
					on_attach = function(client, bufnr)
						disable_formatting(client)
						on_attach(client, bufnr)
					end,
					flags = { debounce_text_changes = 150 },
				})
			end

			nvim_lsp.sumneko_lua.setup(luadev.setup({}))

			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.eslint_d,
					null_ls.builtins.code_actions.eslint_d,
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.fish_indent,
					null_ls.builtins.formatting.shfmt,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.terraform_fmt.with({
						filetypes = { "hcl", "terraform" },
					}),
				},
				on_attach = on_attach,
			})
		end,
	})
end
