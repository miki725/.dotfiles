-- https://github.com/gopasspw/gopass/blob/master/docs/setup.md#securing-your-editor
local gopass = function()
    vim.o.swapfile = false
    vim.o.backup = false
    vim.o.undofile = false
end

vim.api.nvim_create_autocmd({
    "BufNewFile",
    "BufRead",
}, {
    pattern = { "/dev/shm/gopass**", "/private/**/gopass** " },
    callback = gopass,
})
