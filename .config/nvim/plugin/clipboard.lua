-- paste from clipboard
-- https://medium.com/swlh/8-vim-tricks-that-will-take-you-from-beginner-to-expert-817ff4870245
vim.opt.clipboard = { "unnamed", "unnamedplus" }

-- use built-in OSC52 for SSH clipboard support (replaces ojroques/nvim-osc52)
-- skip in GUI environments (e.g. neovide) where OSC52 stalls waiting for the terminal
if vim.fn.has("gui_running") == 0 then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
            ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
            ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        },
    }
end

-- https://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
-- copy current file name (relative/absolute) to system clipboard

local names = {
    cf = { expand = "%", desc = "Copy relative filepath [clipboard]" },
    cF = { expand = "%:p", desc = "Copy absolute filepath [clipboard]" },
    ct = { expand = "%:t", desc = "Copy filename [clipboard]" },
    cT = { expand = "%:p:h", desc = "Copy folder [clipboard]" },
}

for key, lookup in pairs(names) do
    vim.keymap.set("n", "<leader>" .. key, function()
        local value = vim.fn.expand(lookup.expand)
        vim.fn.setreg("*", value)
        vim.fn.setreg("+", value)
        print(value)
    end, { desc = lookup.desc })
end
