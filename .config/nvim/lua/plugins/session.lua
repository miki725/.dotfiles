-- save session per cwd on exit and restore it when nvim starts without file args.
-- the vim alias (fish config.fish) sets NVIM_NO_RESTORE to start on the dashboard instead
-- where "s" restores the session. sessions are still saved on exit.
-- tmux-resurrect reruns nvim with its original args but not env so plain nvim gets its session back
return {
    {
        "rmagatti/auto-session",
        lazy = false,
        init = function()
            -- restores buffer-local options like filetype so highlighting works after restore
            vim.opt.sessionoptions:append("localoptions")
        end,
        opts = {
            suppressed_dirs = { "~/", "/tmp" },
            bypass_save_filetypes = { "gitcommit" },
            auto_restore = vim.env.NVIM_NO_RESTORE == nil,
        },
    },
}
