return {
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap-python",
        },
        cmd = { "VenvSelect" },
        ft = { "python" },
        opts = {
            settings = {
                search = {
                    poetry = {
                        command = "$FD '/bin/python$' ~/.cache/pypoetry/virtualenvs --full-path --no-ignore",
                    },
                },
            },
            options = {},
        },
    },
}
