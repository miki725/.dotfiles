-- save session per cwd on exit and restore it when nvim starts without file args
-- tmux-resurrect reruns nvim with its original args so plain nvim gets its session back
return {
    {
        "rmagatti/auto-session",
        lazy = false,
        opts = {
            suppressed_dirs = { "~/", "/tmp" },
            bypass_save_filetypes = { "gitcommit" },
        },
    },
}
