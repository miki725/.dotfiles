return {
    {
        "gbprod/yanky.nvim",
        keys = {
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text [Yankiy]" },
            { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor [Yanky]" },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor [Yanky]" },
            { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history [Yanky]" },
            { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history [Yanky]" },
        },
        cmd = { "YankyRingHistory", "YankyClearHistory" },
        opts = {
            ring = {
                history_length = 100,
                storage = "memory",
                sync_with_numbered_registers = true,
                cancel_event = "update",
                ignore_registers = { "_" },
            },
            system_clipboard = {
                sync_with_ring = true,
            },
            highlight = {
                timer = 250,
            },
        },
    },
}
