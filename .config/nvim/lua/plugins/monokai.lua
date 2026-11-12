return {
    {
        "tanvirtin/monokai.nvim",
        lazy = false,
        priority = 1000,
        -- safe to keep when editing gopass secrets. see init.lua
        cond = true,
        opts = function()
            local monokai = require("monokai")
            local palette = monokai.classic
            local cursor_hold = {
                bg = palette.red,
                fg = palette.white,
            }
            return {
                custom_hlgroups = {
                    IlluminatedWordText = cursor_hold,
                    IlluminatedWordRead = cursor_hold,
                    IlluminatedWordWrite = cursor_hold,
                    FlashLabel = {
                        bg = palette.base0,
                        fg = palette.orange,
                        style = "bold",
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
                    -- picker dirname defaults to NonText (base5) which is barely visible
                    SnacksPickerDir = {
                        fg = palette.grey,
                    },
                    SnacksIndentScope = {
                        fg = palette.base6,
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
