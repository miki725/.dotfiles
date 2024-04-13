return {
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && yarn install",
        cond = function()
            return vim.fn.executable("yarn") > 0
        end,
        ft = { "markdown" },
        init = function()
            vim.g.mkdp_open_to_the_world = 1
            vim.g.mkdp_echo_preview_url = 1
        end,
    },
}
