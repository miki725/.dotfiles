-- save session per cwd on exit and restore it when nvim starts without file args
-- tmux-resurrect relaunches plain nvim to restore it. see @resurrect-processes in ~/.tmux.conf
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
