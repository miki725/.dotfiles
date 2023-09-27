return {
    {
        "tanvirtin/monokai.nvim",
        lazy = false,
        priority = 1000,
        opts = function()
            local monokai = require("monokai")
            local palette = monokai.classic
            return {
                custom_hlgroups = {
                    LspReferenceRead = {
                        bg = palette.red,
                        fg = palette.white,
                    },
                    LspReferenceText = {
                        bg = palette.red,
                        fg = palette.white,
                    },
                    LspReferenceWrite = {
                        bg = palette.red,
                        fg = palette.white,
                    },
                    TSDefinition = {
                        bg = palette.red,
                        fg = palette.white,
                    },
                    TSDefinitionUsage = {
                        bg = palette.red,
                        fg = palette.white,
                    },
                    TSCurrentScope = {
                        bg = palette.red,
                        fg = palette.white,
                    },
                    GitSignsAdd = {
                        fg = palette.green,
                    },
                    GitSignsDelete = {
                        fg = palette.pink,
                    },
                    GitSignsChange = {
                        fg = palette.orange,
                    },
                    TabLine = {
                        bg = palette.base2,
                        fg = palette.base6,
                    },
                    TabLineSel = {
                        bg = palette.base5,
                        fg = palette.white,
                        style = "bold",
                    },
                    TabLineFill = {
                        bg = palette.base2,
                    },
                },
            }
        end,
    },
}
