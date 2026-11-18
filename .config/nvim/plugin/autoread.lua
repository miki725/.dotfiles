-- reload buffers whose files change outside nvim (e.g. claude in another tmux pane).
-- unmodified buffers reload, modified ones get nvim's prompt to keep them or load the file.
-- reloads are undoable for files under 'undoreload' lines (default 10000)
vim.o.autoread = true

-- autoread only acts when something checks timestamps so check every second, also while nvim
-- is not focused. it is a stat per loaded buffer and unlike file watchers handles atomic saves
local function checktime()
    -- :checktime is not allowed in the command-line window (q:)
    if vim.fn.getcmdwintype() == "" then
        vim.cmd.checktime()
    end
end
vim.uv.new_timer():start(1000, 1000, vim.schedule_wrap(checktime))

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = vim.api.nvim_create_augroup("autoread", { clear = true }),
    callback = function(args)
        local name = vim.fn.fnamemodify(args.file, ":~:.")
        vim.notify("reloaded " .. name .. " (u to undo)", vim.log.levels.INFO, { title = "File changed" })
    end,
})
