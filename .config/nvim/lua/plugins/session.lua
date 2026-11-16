-- save session per cwd on exit and restore it when nvim starts without file args
-- tmux-resurrect reruns nvim with its original args so plain nvim gets its session back
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
        },
    },
}
