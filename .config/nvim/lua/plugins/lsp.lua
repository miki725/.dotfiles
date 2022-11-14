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
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = {
        source = "always", -- Or "if_many"
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

return function(use)
    use({
        "neovim/nvim-lspconfig",
        requires = {
            "jose-elias-alvarez/null-ls.nvim",
            "folke/trouble.nvim",
            "folke/lsp-colors.nvim",
            "weilbith/nvim-code-action-menu",
            "ray-x/lsp_signature.nvim",
            "folke/neodev.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local is_binary_installed = function(binary)
                return vim.fn.executable(binary) > 0
            end

            local is_lsp_installed = function(server)
                return is_binary_installed(server.document_config.default_config.cmd[1])
            end

            if is_binary_installed("lua-language-server") then
                require("neodev").setup({})
            end

            -- shows all violations in a project
            require("trouble").setup({})

            require("lsp_signature").setup({ --
                floating_window = true,
                toggle_key = "<C-L>",
                hint_enable = false,
            })

            local nvim_lsp = require("lspconfig")
            local null_ls = require("null-ls")
            local helpers = require("null-ls.helpers")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            local lsp_formatting = function(bufnr)
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

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach_common = function(client, bufnr)
                -- Mappings.
                local opts = { noremap = true, silent = true }
                local function nmap(...)
                    vim.api.nvim_buf_set_keymap(bufnr, ...)
                end

                -- See `:help vim.lsp.*` for documentation on any of the below functions
                nmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
                nmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
                nmap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
                nmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
                -- moved to fzf as it allows to easily open in new tab/split/etc
                -- nmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
                nmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
                nmap("n", "L", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                nmap("n", "<leader>qf", ":CodeActionMenu<CR>", opts)
                nmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                nmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
                nmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

                vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
                vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
                vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
                vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
                vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
                vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
                vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
                vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
                vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
                vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
                vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
                vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
                vim.cmd("command! LspStopServers lua vim.lsp.stop_client(vim.lsp.get_active_clients())")

                -- delay before float appears or autocomplete shows up
                vim.o.updatetime = 250
                vim.cmd("autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focusable=false})")

                if client.server_capabilities.document_highlight then
                    vim.cmd([[
                    augroup lsp_document_highlight
                        autocmd! * <buffer>
                        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                    augroup END
                    ]])
                end
            end

            local servers = {
                "bashls",
                "clangd",
                "graphql",
                "prismals",
                "pyright",
                "terraformls",
                "tsserver",
                "sumneko_lua",
            }

            for _, lsp in pairs(servers) do
                if is_lsp_installed(nvim_lsp[lsp]) then
                    nvim_lsp[lsp].setup({
                        on_attach = on_attach_common,
                        flags = { debounce_text_changes = 150 },
                    })
                end
            end

            local sources = {
                null_ls.builtins.diagnostics.eslint_d,
                null_ls.builtins.diagnostics.flake8,
                null_ls.builtins.diagnostics.mypy,
                null_ls.builtins.code_actions.eslint_d,
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.fish_indent,
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
                    return vim.fn.executable(cmd) > 0
                end
            end

            null_ls.setup({
                sources = sources,
                on_attach = function(client, bufnr)
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            lsp_formatting(bufnr)
                        end,
                    })

                    vim.cmd("command! NullLsStop lua vim.lsp.stop_client(" .. client.id .. ")")

                    on_attach_common(client, bufnr)
                end,
            })
        end,
    })
end
