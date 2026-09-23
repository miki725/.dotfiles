return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "ribru17/blink-cmp-spell",
            "saghen/blink.compat",
            "ray-x/cmp-treesitter",
        },
        version = "*",
        opts = {
            snippets = { preset = "luasnip" },

            keymap = {
                preset = "none",
                ["<C-Space>"] = { "show", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<CR>"] = { "select_and_accept", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            },

            completion = {
                trigger = {
                    show_on_keyword = false,
                    show_on_trigger_character = false,
                },
                menu = {
                    auto_show = false,
                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            { "source_name" },
                        },
                    },
                },
                documentation = { auto_show = true },
            },

            sources = {
                default = {
                    "lazydev",
                    "lsp",
                    "path",
                    "snippets",
                    "treesitter",
                    "buffer",
                    "spell",
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    treesitter = {
                        name = "treesitter",
                        module = "blink.compat.source",
                        score_offset = 30,
                        max_items = 10,
                        opts = { name = "treesitter" },
                    },
                    lsp = {
                        score_offset = 100,
                        max_items = 10,
                    },
                    path = {
                        score_offset = 110,
                        max_items = 5,
                    },
                    buffer = {
                        score_offset = 80,
                        max_items = 5,
                    },
                    spell = {
                        name = "Spell",
                        module = "blink-cmp-spell",
                        score_offset = 70,
                        max_items = 5,
                    },
                },
            },

            cmdline = {
                enabled = true,
                keymap = {
                    preset = "none",
                    ["<C-Space>"] = { "show", "fallback" },
                    ["<C-e>"] = { "cancel", "fallback" },
                    ["<CR>"] = { "select_accept_and_enter", "fallback" },
                    ["<Tab>"] = { "select_next", "show", "fallback" },
                    ["<S-Tab>"] = { "select_prev", "fallback" },
                },
                sources = function()
                    local type = vim.fn.getcmdtype()
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    if type == ":" then
                        return { "cmdline", "path" }
                    end
                    return {}
                end,
                completion = {
                    list = {
                        selection = { preselect = true, auto_insert = true },
                    },
                    menu = { auto_show = false },
                },
            },
        },
    },
}
