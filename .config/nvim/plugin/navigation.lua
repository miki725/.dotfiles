-- easier switch between windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left buffer [nagivation]" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom buffer [nagivation]" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up buffer [nagivation]" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right buffer [nagivation]" })

vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left buffer [nagivation]" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom buffer [nagivation]" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to up buffer [nagivation]" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right buffer [nagivation]" })

-- have %% expand current file directory
-- http://vimcasts.org/episodes/the-edit-command/
vim.keymap.set("c", "%%", "<C-R>=fnameescape(expand('%:h')).'/'<cr>", { desc = "Expand file directory [navigation]" })

-- jump to the last position when reopening a file
vim.api.nvim_create_autocmd({
    "BufReadPost",
}, {
    callback = function()
        -- https://www.reddit.com/r/neovim/comments/ucgxmj/how_to_update_the_lastpositionjump_to_a_lua/
        local ft = vim.opt_local.filetype:get()
        -- don't apply to git messages
        if ft:match("commit") or ft:match("rebase") then
            return
        end
        -- restore last position
        local markpos = vim.api.nvim_buf_get_mark(0, '"')
        local line = markpos[1]
        local col = markpos[2]
        -- if in range, go there
        if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
            vim.api.nvim_win_set_cursor(0, { line, col })
        end
    end,
})
