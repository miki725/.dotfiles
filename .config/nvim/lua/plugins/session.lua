-- save session per cwd on exit and restore it when nvim starts without file args.
-- the vim alias (fish config.fish) sets NVIM_NO_RESTORE to start on the dashboard instead
-- where "s" restores the session. sessions are still saved on exit.
-- tmux-resurrect reruns nvim with its original args but not env so plain nvim gets its session back
-- NVIM_NO_SESSION skips sessions entirely, e.g. for the tmux diff review popup (.tmux.conf)
return {
    {
        "rmagatti/auto-session",
        lazy = false,
        init = function()
            -- restores buffer-local options like filetype so highlighting works after restore
            vim.opt.sessionoptions:append("localoptions")
        end,
        opts = {
            enabled = vim.env.NVIM_NO_SESSION == nil,
            suppressed_dirs = { "~/", "/tmp" },
            -- nor anywhere under tmp. /tmp is /private/tmp on macos as nvim resolves the symlink.
            -- not with suppressed_dirs as its globs walk the whole tree on disk on every check
            auto_create = function()
                local cwd = vim.fn.getcwd()
                return not (vim.startswith(cwd, "/tmp/") or vim.startswith(cwd, "/private/tmp/"))
            end,
            bypass_save_filetypes = { "gitcommit" },
            auto_restore = vim.env.NVIM_NO_RESTORE == nil,
        },
    },
}
