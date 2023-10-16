-- for GUI apps like neovide
vim.o.guifont = "Hack Nerd Font"
vim.g.neovide_cursor_animation_length = 0

local pwd = vim.api.nvim_exec("pwd", true)
local is_gui = vim.fn.has("gui_running") > 0
if pwd == "/" and is_gui then
    vim.cmd.cd(vim.fn.expand("$HOME"))
end
