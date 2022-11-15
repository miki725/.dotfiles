return function(use)
    use({
        "McAuleyPenney/tidy.nvim",
        event = "BufWritePre",
        config = function()
            require("tidy").setup()
        end,
    })
end
