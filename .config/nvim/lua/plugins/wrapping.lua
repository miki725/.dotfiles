return function(use)
    use({
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup({
                auto_set_mode_filetype_allowlist = {
                    "asciidoc",
                    "gitcommit",
                    "latex",
                    "mail",
                    "markdown",
                    "tex",
                    "text",
                },
            })
        end,
    })
end
