return {
    {
        -- startup screen
        "goolord/alpha-nvim",
        opts = function()
            return require("alpha.themes.startify").opts
        end,
    },
}
