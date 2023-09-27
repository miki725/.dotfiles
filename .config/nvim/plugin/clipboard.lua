-- paste from clipboard
-- https://medium.com/swlh/8-vim-tricks-that-will-take-you-from-beginner-to-expert-817ff4870245
vim.o.clipboard = "unnamed"
vim.opt.clipboard:append("unnamedplus")

-- https://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
-- copy current file name (relative/absolute) to system clipboard

local names = {
    cf = "%", -- relative path
    cF = "%:p", -- absolute path
    ct = "%:t", -- filename
    cT = "%:p:h", -- folder
}

for key, lookup in pairs(names) do
    vim.keymap.set("n", "<leader>" .. key, function()
        local value = vim.fn.expand(lookup)
        vim.fn.setreg("*", value)
        vim.fn.setreg("+", value)
        print(value)
    end)
end
