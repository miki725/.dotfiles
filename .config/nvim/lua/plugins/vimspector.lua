return {
    {
        "puremourning/vimspector",
        keys = {
            { "<leader>dd", "<Plug>VimspectorContinue" },
            { "<leader>de", ":call vimspector#Reset()<CR>" },
            { "<leader>dc", "<Plug>VimspectorContinue" },
            { "<leader>dt", "<Plug>VimspectorToggleBreakpoint" },
            { "<leader>dT", ":call vimspector#ClearBreakpoints()<CR>" },
            { "<leader>dh", "<Plug>VimspectorStepOut" },
            { "<leader>dj", "<Plug>VimspectorStepOver" },
            { "<leader>dk", "<Plug>VimspectorRunToCursor" },
            { "<leader>dl", "<Plug>VimspectorStepInto" },
        },
    },
}
