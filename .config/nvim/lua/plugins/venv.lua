return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap-python",
        },
        cmd = { "VenvSelect" },
        ft = { "python" },
        init = function()
            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = function()
                    local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
                    if vim.fn.executable(venv_python) == 1 then
                        require("venv-selector").activate_from_path(venv_python)
                    end
                end,
            })
        end,
        opts = {
            settings = {
                search = {
                    poetry = {
                        command = "$FD '/bin/python$' ~/.cache/pypoetry/virtualenvs --full-path --no-ignore",
                    },
                    uv = {
                        command = "$FD 'python$' ~/.local/share/uv",
                    },
                },
            },
            options = {
                require_lsp_activation = false,
            },
        },
    },
}
