return {
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", "gc", desc = "Comment Lines [Comment]" },
            { "gb", "gb", desc = "Comment Block [Comment]" },
            { "gc", "gc", desc = "Comment Lines [Comment]", mode = "v" },
            { "gb", "gb", desc = "Comment Block [Comment]", mode = "v" },
        },
        config = function()
            require("Comment").setup({
                padding = true,
                sticky = true,
                ignore = "^$",
                toggler = {
                    line = "gcc",
                    block = "gbc",
                },
                opleader = {
                    line = "gc",
                    block = "gb",
                },
                extra = {
                    above = "gcO",
                    below = "gco",
                    eol = "gcA",
                },
                mappings = {
                    basic = true,
                    extra = true,
                    extended = false,
                },
                pre_hook = nil,
                post_hook = nil,
            })
        end,
    },
}
