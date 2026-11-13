local tool_pairs = require("utils.tool_pairs")

local semantic_tokens_max_lines = 5000

-- detached client ids are kept in buffer var so <leader>tl can reattach them
local detach = function(bufnr, client)
    vim.b[bufnr].lsp_detached = vim.list_extend(vim.b[bufnr].lsp_detached or {}, { client.id })
    vim.lsp.buf_detach_client(bufnr, client.id)
end

local on_attach = function()
    -- dont overwrite vim formatting with LSP so things like gq keep working as normal.
    -- nvim sets it on attach and again whenever a server registers any capability later
    vim.api.nvim_create_autocmd("OptionSet", {
        group = vim.api.nvim_create_augroup("LspNoFormatexpr", { clear = true }),
        pattern = "formatexpr",
        callback = function()
            if vim.v.option_new == "v:lua.vim.lsp.formatexpr()" then
                vim.bo.formatexpr = ""
            end
        end,
    })

    Snacks.util.lsp.on(function(bufnr, client)
        -- servers which finish starting after <leader>tl disabled them
        if vim.b[bufnr].lsp_detached then
            detach(bufnr, client)
            return
        end

        -- semantic tokens re-request highlights on every edit which lags in large files
        -- so treesitter handles those alone. <leader>ts toggles. snacks bigfile disables lsp above 1.5MB
        if vim.api.nvim_buf_line_count(bufnr) > semantic_tokens_max_lines then
            vim.lsp.semantic_tokens.enable(false, { bufnr = bufnr })
        end
    end)
end

local keymaps = function()
    -- snacks only maps in buffers where some server supports the method so vim defaults
    -- like gd and L keep working with servers which dont, e.g. oxfmt or vale_ls in markdown
    local map = function(method, lhs, rhs, desc)
        Snacks.keymap.set("n", lhs, rhs, { lsp = { method = method }, desc = desc })
    end
    -- nvim defaults:
    --   grn - rename
    --   gra - code action
    --   grr - references
    --   grx - run codelens
    --   K   - hover
    --   [d  - prev diagnostic
    --   ]d  - next diagnostic
    -- overrides of defaults and extras:
    map("textDocument/declaration", "grD", Snacks.picker.lsp_declarations, "Picker: Goto declaration [LSP]")
    map("textDocument/definition", "gd", Snacks.picker.lsp_definitions, "Picker: Goto definition [LSP]")
    map("textDocument/typeDefinition", "grt", Snacks.picker.lsp_type_definitions, "Picker: Goto type [LSP]")
    map("textDocument/implementation", "gri", Snacks.picker.lsp_implementations, "Picker: Goto implementation [LSP]")
    map("textDocument/signatureHelp", "L", vim.lsp.buf.signature_help, "Show signature [LSP]")
end

return {
    {
        "neovim/nvim-lspconfig",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        dependencies = {
            "saghen/blink.cmp",
            -- shows all violations in a project
            {
                "folke/trouble.nvim",
                cmd = { "Trouble" },
                config = true,
            },
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                    integrations = {
                        lspconfig = false,
                        cmp = false,
                    },
                },
            },
        },
        init = function()
            -- delay before float appears or autocomplete shows up
            vim.o.updatetime = 250

            -- lspconfig skips its :Lsp* commands since nvim 0.12 has :lsp enable/disable/stop/restart
            vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
                desc = "Language server status [LSP]",
            })
        end,
        config = function()
            vim.lsp.config("*", {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
            })

            on_attach()
            keymaps()

            -- <leader>tl detaches language servers from current buffer and reattaches them.
            -- :lsp disable/enable/stop/restart [name] for individual servers
            Snacks.toggle
                .new({
                    id = "lsp",
                    name = "language servers for buffer [LSP]",
                    -- enabled unless disabled for buffer. servers which are still starting
                    -- are not attached yet so counting attached ones shows disabled
                    get = function()
                        return vim.b.lsp_detached == nil
                    end,
                    set = function(state)
                        local bufnr = vim.api.nvim_get_current_buf()
                        if state then
                            for _, id in ipairs(vim.b[bufnr].lsp_detached or {}) do
                                if vim.lsp.get_client_by_id(id) then
                                    vim.lsp.buf_attach_client(bufnr, id)
                                end
                            end
                            vim.b[bufnr].lsp_detached = nil
                        else
                            vim.b[bufnr].lsp_detached = {}
                            for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                                detach(bufnr, client)
                            end
                        end
                    end,
                })
                :map("<leader>tl")

            Snacks.toggle
                .new({
                    id = "semantic_tokens",
                    name = "semantic tokens for buffer [LSP]",
                    get = function()
                        return vim.lsp.semantic_tokens.is_enabled({ bufnr = 0 })
                    end,
                    set = function(state)
                        vim.lsp.semantic_tokens.enable(state, { bufnr = 0 })
                    end,
                })
                :map("<leader>ts")

            local servers = {
                -- only one side of each pair runs per buffer: legacy tool in repos configured for it
                -- otherwise the newer one. see utils/tool_pairs
                eslint = tool_pairs.lsp("eslint"), -- or oxlint
                oxlint = tool_pairs.lsp("oxlint"), -- or eslint
                oxfmt = tool_pairs.lsp("oxfmt"), -- or prettierd via conform
                basedpyright = tool_pairs.lsp("basedpyright"), -- or ty
                ty = tool_pairs.lsp("ty"), -- or basedpyright

                -- runs shellcheck and formats with shfmt when installed.
                -- repo .editorconfig wins over these and buffer indent is used
                bashls = {
                    settings = {
                        bashIde = {
                            shfmt = {
                                caseIndent = true, -- indent switch cases
                                spaceRedirects = true, -- redirect operators are followed by space
                                binaryNextLine = true, -- binary ops like && or | (pipe) start the line
                            },
                        },
                    },
                },
                clangd = {},
                gopls = {},
                graphql = {},
                lua_ls = {
                    -- https://github.com/LunarVim/LunarVim/issues/4049#issuecomment-1634539474
                    root_markers = {
                        "lazy-lock.json",
                        "stylua.toml",
                    },
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                        },
                    },
                },
                nim_langserver = {},
                prismals = {},
                ruff = {},
                terraformls = {},
                -- typescript 7 native language server
                tsc = {
                    binary = "tsc",
                    -- oxfmt formats ts when installed. prettier repos format with prettierd via conform
                    -- which skips language servers anyway. otherwise tsc formats
                    on_init = function(client)
                        if vim.fn.executable("oxfmt") == 1 then
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end
                    end,
                },
                vale_ls = {}, -- prose linter/spell checker
            }

            for name, opts in pairs(servers) do
                -- nvim skips servers whose cmd is not executable
                -- but some lspconfig cmds are functions so those specify binary
                local binary = opts.binary
                opts.binary = nil
                if not binary or vim.fn.executable(binary) == 1 then
                    vim.lsp.config(name, opts)
                    vim.lsp.enable(name)
                end
            end
        end,
    },
}
