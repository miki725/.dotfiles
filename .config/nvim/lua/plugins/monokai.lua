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
            local ignored_fg = "#8a93a0"
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
                    -- untracked defaults to NonText (base5) which makes explorer in fresh repos
                    -- (e.g. ~/Documents) unreadable
                    SnacksPickerGitStatusUntracked = {
                        fg = palette.base7,
                        style = "italic",
                    },
                    -- ignored also defaults to NonText. keep it dimmer than untracked but readable
                    -- with a slight cool tint to tell it apart from neutral grey untracked
                    SnacksPickerGitStatusIgnored = {
                        fg = ignored_fg,
                    },
                    SnacksPickerPathIgnored = {
                        fg = ignored_fg,
                    },
                    -- inline git blame pill on cursor line. see gitsigns.lua
                    GitSignsCurrentLineBlame = {
                        bg = palette.base5,
                        fg = palette.base7,
                        style = "italic",
                    },
                    GitSignsCurrentLineBlameEdge = {
                        fg = palette.base5,
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
