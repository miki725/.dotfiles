return {
    {
        "ibhagwan/fzf-lua",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
        cmd = {
            "FzfLua",
        },
        keys = {
            { "<leader>ff", ":FzfLua builtin<CR>" },
            { "<C-P>", ":FzfLua git_files<CR>" },
            { "<C-B>", ":FzfLua buffers<CR>" },
            { "<C-t>", ":FzfLua btags<CR>" },
            { "<A-t>", ":FzfLua tags<CR>" },
            { "z=", ":FzfLua spell_suggest<CR>" },
            { "gr", ":FzfLua lsp_references<CR>" },
        },
        opts = {
            lsp = {
                -- make lsp requests synchronous so they work with null-ls
                async_or_timeout = 3000,
            },
        },
    },
}
