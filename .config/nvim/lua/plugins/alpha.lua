return function(use)
    use({
        "goolord/alpha-nvim",
        config = function()
            require("alpha").setup(require("alpha.themes.startify").opts)
        end,
    })
end
