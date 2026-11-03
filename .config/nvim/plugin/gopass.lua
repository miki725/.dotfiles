-- https://github.com/gopasspw/gopass/blob/master/docs/setup.md#securing-your-editor
-- gopass own vim -c autocmd only runs after the secret is already loaded so it cant be relied on.
-- plugins are disabled in init.lua and undofile in plugin/undo.lua
if not require("gopass").active then
    return
end

vim.o.shadafile = "NONE"
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = false
