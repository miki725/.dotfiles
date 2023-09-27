return {
    -- adds git commands such as :Gdiffssplit for 3-way-merge
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb", -- required for gbrowse
        },
        cmd = {
            "GBrowse",
            "Gdiffsplit",
            "Git",
            "Gvdiffsplit",
        },
        init = function()
            vim.cmd([[
				command! -nargs=* Browse
			]])
        end,
    },
}
