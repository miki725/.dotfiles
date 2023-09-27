return {
    {
        "puremourning/vimspector",
        keys = {
            { "<leader>dd", "<Plug>VimspectorContinue", desc = "Start debugging [Vimspector]" },
            { "<leader>de", ":call vimspector#Reset()<CR>", desc = "End debugging [Vimspector]" },
            { "<leader>dc", "<Plug>VimspectorContinue", desc = "Continue [Vimspector]" },
            { "<leader>dt", "<Plug>VimspectorToggleBreakpoint", desc = "Toggle breakpoint [Vimspector]" },
            { "<leader>dT", ":call vimspector#ClearBreakpoints()<CR>", desc = "Clear breakpoints [Vimspector]" },
            { "<leader>dh", "<Plug>VimspectorStepOut", desc = "Step out [Vimspector]" },
            { "<leader>dj", "<Plug>VimspectorStepOver", desc = "Step over [Vimspector]" },
            { "<leader>dk", "<Plug>VimspectorRunToCursor", desc = "Run to cursor [Vimspector]" },
            { "<leader>dl", "<Plug>VimspectorStepInto", desc = "Step into [Vimspector]" },
        },
    },
}
