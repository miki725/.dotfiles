local telescope_utils = require("utils.telescope")

return {
    telescope_utils.register({
        "AckslD/nvim-neoclip.lua",
        event = "TextYankPost",
        keys = {
            { "<leader>y", "<cmd>Telescope neoclip<cr>", desc = "Clipboard history [neoclip]" },
        },
        opts = {
            history = 100,
            enable_persistent_history = false,
            preview = true,
        },
        extensions = {
            neoclip = {},
        },
    }),
}
