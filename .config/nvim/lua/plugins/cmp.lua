return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "f3fora/cmp-spell",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            -- "quangnguyen30192/cmp-nvim-tags", -- pretty slow
            "ray-x/cmp-treesitter",
            {
                -- shows LSP kind for the autocomplete icon+text
                "onsails/lspkind-nvim",
                config = function()
                    require("lspkind").init()
                end,
            },
        },
        init = function()
            vim.opt.completeopt = { "menu", "menuone", "noselect" }
        end,
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            cmp.setup({

                completion = { autocomplete = false },

                view = {
                    entries = "custom", -- can be "custom", "wildmenu" or "native"
                },

                formatting = {
                    format = lspkind.cmp_format({
                        with_text = true, -- do not show text alongside icons
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        menu = {
                            buffer = "(Buffer)",
                            calc = "(Calc)",
                            emoji = "(Emoji)",
                            gh_issues = "(Issues)",
                            luasnip = "(Snippet)",
                            nvim_lsp = "(LSP)",
                            path = "(Path)",
                            treesitter = "(TS)",
                            spell = "(Spell)",
                        },
                    }),
                },

                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = {
                        i = function(fallback)
                            if not cmp.select_next_item() then
                                fallback()
                            end
                        end,
                    },
                    ["<S-Tab>"] = {
                        i = function(fallback)
                            if not cmp.select_prev_item() then
                                fallback()
                            end
                        end,
                    },
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                }),

                sources = cmp.config.sources({
                    {
                        name = "path",
                        priority_weight = 110,
                        max_item_count = 5,
                    },
                    {
                        name = "nvim_lsp",
                        priority_weight = 100,
                        max_item_count = 10,
                    },
                    {
                        name = "treesitter",
                        priority_weight = 90,
                        max_item_count = 10,
                    },
                    {
                        name = "buffer",
                        priority_weight = 80,
                        max_item_count = 5,
                    },
                    {
                        name = "spell",
                        priority_weight = 70,
                        max_item_count = 5,
                    },
                    -- { name = "tags" }, -- pretty slow
                }),
            })

            cmp.setup.cmdline("/", {
                completion = { autocomplete = false },
                mapping = cmp.mapping.preset.cmdline({
                    ["<C-Space>"] = {
                        c = cmp.mapping.complete(),
                    },
                }),
                sources = { --
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                completion = { autocomplete = false },
                mapping = cmp.mapping.preset.cmdline({
                    ["<C-Space>"] = {
                        c = cmp.mapping.complete(),
                    },
                    ["<Tab>"] = {
                        c = function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                if cmp.complete() then
                                    cmp.select_next_item()
                                else
                                    fallback()
                                end
                            end
                        end,
                    },
                }),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })

            -- Setup lspconfig.
            -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
            -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
            -- capabilities = capabilities
            -- }
        end,
    },
}
