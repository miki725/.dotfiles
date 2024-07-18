-- for GUI apps like neovide
vim.o.guifont = "Hack Nerd Font"

local pwd = vim.api.nvim_exec("pwd", true)
local is_gui = vim.fn.has("gui_running") > 0
if pwd == "/" and is_gui then
    vim.cmd.cd(vim.fn.expand("$HOME"))
end

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
    vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end
