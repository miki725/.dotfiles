local telescope_utils = require("utils.telescope")

local is_binary_installed = function(binary)
    return vim.fn.executable(binary) > 0
end

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvimtools/none-ls.nvim",
            "nvimtools/none-ls-extras.nvim",
            "gbprod/none-ls-shellcheck.nvim",
            "nvim-lua/plenary.nvim",
            -- shows all violations in a project
            {
                "folke/trouble.nvim",
                cmd = { "TroubleToggle", "Trouble" },
                config = true,
            },
            {
                "weilbith/nvim-code-action-menu",
                cmd = "CodeActionMenu",
            },
            {
                "ray-x/lsp_signature.nvim",
                opts = {
                    -- false until https://github.com/ray-x/lsp_signature.nvim/issues/252
                    floating_window = true,
                    toggle_key = "<C-L>",
                    hint_enable = false,
                },
            },
            {
                "folke/neodev.nvim",
                cond = function()
                    return is_binary_installed("lua-language-server")
                end,
                config = true,
            },
            telescope_utils.register({
                "adoyle-h/lsp-toggle.nvim",
                cmd = { "ToggleLSP", "ToggleNullLSP" },
                opts = {
                    telescope = false, -- its loaded by register()
                },
                extensions = {
                    ToggleLSP = {},
                    ToggleNullLSP = {},
                },
            }),
        },
        init = function()
            -- delay before float appears or autocomplete shows up
            vim.o.updatetime = 250

            -- show LSP floating window with border
            local border = {
                { "╭", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╮", "FloatBorder" },
                { "│", "FloatBorder" },
                { "╯", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╰", "FloatBorder" },
                { "│", "FloatBorder" },
            }
            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or border
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end

            -- show symbolc in the gutter for error types
            local signs = {
                Error = " ",
                Warn = " ",
                Info = " ",
                Hint = "󰌵",
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            vim.diagnostic.config({
                virtual_text = false,
                signs = true,
                float = {
                    source = "always", -- "always" or "if_many"
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })
        end,
        config = function()
            local is_lsp_installed = function(server)
                return is_binary_installed(server.document_config.default_config.cmd[1])
            end

            local lspconfig = require("lspconfig")
            local lspconfig_configs = require("lspconfig.configs")
            local lspconfig_util = require("lspconfig.util")
            local null_ls = require("null-ls")
            local helpers = require("null-ls.helpers")
            local format_group = vim.api.nvim_create_augroup("LspFormat", { clear = true })

            local lsp_format = function(bufnr)
                return function()
                    vim.lsp.buf.format({
                        filter = function(client)
                            -- if null-ls has formatter for this filetype,
                            -- then only let null-ls format this buffer
                            -- otherwise anything is valid
                            local filetype = vim.bo.filetype
                            for _, source in pairs(null_ls.get_sources()) do
                                if source.methods[null_ls.methods.FORMATTING] and source.filetypes[filetype] then
                                    return client.name == "null-ls"
                                end
                            end
                            return true
                        end,
                        bufnr = bufnr,
                    })
                end
            end

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach_common = function(client, bufnr)
                -- dont overwrite vim formatting with LSP
                -- so things like gq keep working as normal
                -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
                vim.bo[bufnr].formatexpr = nil

                local map = function(mode, lhs, rhs, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, lhs, rhs, opts)
                end
                map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration [LSP]" })
                map("n", "gd", vim.lsp.buf.definition, { desc = "Goto defition [LSP]" })
                map("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto type [LSP]" })
                map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto implementation [LSP]" })
                -- moved to fzf as it allows to easily open in new tab/split/etc
                -- map("n", "gr", vim.lsp.buf.references, {desc="Show references [LSP]"})
                map("n", "K", vim.lsp.buf.hover, { desc = "Show type [LSP]" })
                map("n", "L", vim.lsp.buf.signature_help, { desc = "Show signature [LSP]" })
                map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename [LSP]" })
                -- from dep above
                map("n", "<leader>qf", ":CodeActionMenu<cr>", { desc = "Quick fix menu [LSP]" })
                map("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto prev diagnostic [LSP]" })
                map("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic [LSP]" })

                vim.api.nvim_buf_create_user_command(bufnr, "LspHover", vim.lsp.buf.hover, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspSignature", vim.lsp.buf.signature_help, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspDef", vim.lsp.buf.definition, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspTypeDef", vim.lsp.buf.type_definition, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspImplementation", vim.lsp.buf.implementation, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspRefs", vim.lsp.buf.references, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", lsp_format(bufnr), {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspCodeAction", vim.lsp.buf.code_action, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspRename", vim.lsp.buf.rename, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspDiagShow", vim.diagnostic.open_float, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspDiagPrev", vim.diagnostic.goto_prev, {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspDiagNext", vim.diagnostic.goto_next, {})

                -- disable semantic tokens and let treesitter handle syntax highlighting
                client.server_capabilities.semanticTokensProvider = nil

                -- show diagnostic popup for violations on hover
                vim.api.nvim_create_autocmd("CursorHold", {
                    buffer = bufnr,
                    callback = function()
                        vim.diagnostic.open_float(nil, { focusable = false })
                    end,
                })
            end

            -- Check if the config is already defined (useful when reloading this file)
            if not lspconfig_configs.nimlangserver then
                lspconfig_configs.nimlangserver = {
                    default_config = {
                        cmd = { "nimlangserver" },
                        filetypes = { "nim" },
                        root_dir = function(fname)
                            return lspconfig_util.root_pattern("*.nimble")(fname)
                                or lspconfig_util.find_git_ancestor(fname)
                        end,
                        single_file_support = true,
                    },
                }
            end

            local servers = {
                nim_langserver = {},
                pyright = {}, -- slow compared to pylsp for large files
                bashls = {},
                clangd = {},
                gopls = {},
                graphql = {},
                prismals = {},
                pylsp = {},
                terraformls = {},
                ts_ls = {},
                lua_ls = {
                    -- https://github.com/LunarVim/LunarVim/issues/4049#issuecomment-1634539474
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                        },
                    },
                },
            }

            for lsp, opts in pairs(servers) do
                if is_lsp_installed(lspconfig[lsp]) then
                    lspconfig[lsp].setup(vim.tbl_extend("force", opts, {
                        on_attach = on_attach_common,
                        flags = { debounce_text_changes = 150 },
                    }))
                end
            end

            local sources = {
                require("none-ls.diagnostics.eslint_d"),
                require("none-ls.diagnostics.flake8"),
                null_ls.builtins.diagnostics.mypy,
                require("none-ls-shellcheck.diagnostics"),
                require("none-ls-shellcheck.code_actions"),
                null_ls.builtins.diagnostics.vale,
                require("none-ls.code_actions.eslint_d"),
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.fish_indent,
                null_ls.builtins.formatting.gofmt,
                -- null_ls.builtins.formatting.nimpretty,
                null_ls.builtins.formatting.shfmt.with({
                    extra_args = {
                        "-i",
                        "4", -- 4 spaces
                        "-ci", -- indent switch cases
                        "-sr", -- redirect operators are followed by space
                        "-bn", -- binary ops like && or | (pipe) start the line
                    },
                }),
                null_ls.builtins.formatting.stylua.with({
                    extra_args = { "--indent-type", "spaces" },
                }),
                null_ls.builtins.formatting.terraform_fmt.with({
                    filetypes = { "hcl", "terraform" },
                }),
                helpers.make_builtin({
                    name = "importanize",
                    meta = {
                        url = "https://github.com/miki725/importanize",
                        description = "Organize imports",
                    },
                    method = null_ls.methods.FORMATTING,
                    filetypes = { "python" },
                    generator_opts = {
                        command = "importanize",
                        args = {},
                        to_stdin = true,
                    },
                    factory = helpers.formatter_factory,
                }),
            }

            for _, v in pairs(sources) do
                local cmd = v._opts.command
                v.condition = function()
                    return is_binary_installed(cmd)
                end
            end

            null_ls.setup({
                sources = sources,
                on_attach = function(client, bufnr)
                    vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = format_group,
                        buffer = bufnr,
                        callback = lsp_format(bufnr),
                    })

                    vim.api.nvim_buf_create_user_command(bufnr, "NullLsStop", function()
                        vim.lsp.stop_client(client.id)
                    end, {})

                    on_attach_common(client, bufnr)
                end,
            })
        end,
    },
}
