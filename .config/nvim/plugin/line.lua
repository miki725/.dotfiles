-- show line numbers
vim.o.number = true
-- highlight current line
vim.o.cursorline = true
-- show right margin at 120 chars
vim.opt.colorcolumn = { 120 }

-- right margin just past editorconfig max_line_length like editorconfig-vim did.
-- built-in editorconfig only sets textwidth and records applied properties in b:editorconfig
-- on BufRead which runs before BufWinEnter. colorcolumn is window-local so it is set
-- (or reset to the global margin) whenever a buffer is shown in a window
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("editorconfig_colorcolumn", { clear = true }),
    callback = function(args)
        local editorconfig = vim.b[args.buf].editorconfig
        local max_line_length = type(editorconfig) == "table" and tonumber(editorconfig.max_line_length)
        if max_line_length then
            vim.wo[0][0].colorcolumn = tostring(max_line_length + 1)
        else
            vim.wo[0][0].colorcolumn = vim.go.colorcolumn
        end
    end,
})
