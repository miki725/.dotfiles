if not vim.fn.executable("fd") then
	return function() end
end

if not vim.fn.executable("ctags") then
	return function() end
end

vim.g.gutentags_define_advanced_commands = true
vim.g.gutentags_file_list_command = "fd --strip-cwd-prefix"

return function(use)
	use({
		"ludovicchabant/vim-gutentags",
		config = function()
			local luadev = require("lua-dev").setup({})
			local lspconfig = require("lspconfig")
			lspconfig.sumneko_lua.setup(luadev)
		end,
	})
end
