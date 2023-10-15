return {
    {
        "ibhagwan/fzf-lua",
        enabled = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = {
            "FzfLua",
        },
        keys = {
            { "<leader>ff", ":FzfLua builtin<CR>", desc = "Show fzf [FZF]" },
            { "<C-P>", ":FzfLua git_files<CR>", desc = "Search files [FZF]" },
            { "<A-p>", ":FzfLua tabs<CR>", desc = "Search tabs [FZF]" },
            { "<A-P>", ":FzfLua buffers<CR>", desc = "Search buffers [FZF]" },
            { "<C-t>", ":FzfLua btags<CR>", desc = "Search buffer tags [FZF]" },
            { "<A-t>", ":FzfLua tags<CR>", desc = "Search tags [FZF]" },
            { "z=", ":FzfLua spell_suggest<CR>", desc = "Show spelling suggestions [FZF]" },
            { "gr", ":FzfLua lsp_references<CR>", desc = "Show LSP references [FZF]" },
        },
        opts = {
            lsp = {
                -- make lsp requests synchronous so they work with null-ls
                async_or_timeout = 3000,
            },
        },
    },
}
