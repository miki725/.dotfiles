local M = {}

-- list item marker incl optional task checkbox: "* ", "- [ ] ", "1. ", "2) "
local list_item = [[^\s*\%([-*+]\|\d\+[.)]\)\s\+\%(\[.\]\s\+\)\?]]

-- indent new lines to align with the text of a list item on the previous line
-- otherwise fall back to treesitter indent
M.indent = function()
    local text_start = vim.fn.matchend(vim.fn.getline(vim.v.lnum - 1), list_item)
    if text_start >= 0 then
        return text_start
    end
    return require("nvim-treesitter").indentexpr()
end

return M
