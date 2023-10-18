return {
    {
        "ahmedkhalf/jupyter-nvim",
        -- requires nbformat as python dev
        -- which is installed via .Makefile.install
        build = ":UpdateRemotePlugins",
        ft = { "ipynb" },
        config = true,
    },
}
