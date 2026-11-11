local snacks_utils = require("utils.snacks")

return {
    -- only for yank history. no y/p mappings so other features are disabled
    snacks_utils.register({
        "gbprod/yanky.nvim",
        event = "TextYankPost",
        keys = {
            {
                "<leader>y",
                function()
                    Snacks.picker.yanky()
                end,
                desc = "Picker: Yank history [yanky]",
            },
        },
        opts = {
            ring = {
                history_length = 100,
                storage = "memory",
                sync_with_numbered_registers = false,
            },
            -- reading + with osc52 queries the terminal
            system_clipboard = {
                sync_with_ring = false,
            },
            highlight = {
                on_put = false,
                on_yank = false,
            },
            preserve_cursor_position = {
                enabled = false,
            },
            textobj = {
                enabled = false,
            },
        },
        -- yanky registers its source on setup which is lazy
        pickers = {
            yanky = snacks_utils.lazy_source(function()
                return require("yanky.sources.snacks").config
            end),
        },
    }),
}
