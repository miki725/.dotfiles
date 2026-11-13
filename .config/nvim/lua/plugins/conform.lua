return {
    {
        "stevearc/conform.nvim",
        -- loaded with lspconfig so <leader>tf toggle exists before first save
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        cmd = { "ConformInfo" },
        -- tool_pairs reads oxfmt filetypes from lspconfig
        dependencies = { "neovim/nvim-lspconfig" },
        config = function(_, opts)
            require("conform").setup(opts)

            -- <leader>tf skips formatting on save for current buffer. :LspFormat still works
            Snacks.toggle
                .new({
                    id = "format_on_save",
                    name = "format on save for buffer [Conform]",
                    get = function()
                        return vim.b.format_on_save ~= false
                    end,
                    set = function(state)
                        vim.b.format_on_save = state
                    end,
                })
                :map("<leader>tf")

            vim.api.nvim_create_user_command("LspFormat", function()
                require("conform").format()
            end, { desc = "Format buffer [Conform]" })
        end,
        -- function so tool_pairs can read lspconfig filetypes once it is loaded
        opts = function()
            -- only formatters which are not language servers. everything else
            -- formats with attached language servers, e.g. bashls (shfmt), ruff, oxfmt.
            -- each lists filetypes it formats plus any conform formatter options.
            -- skip_for_lsp skips formatter when that language server is attached and formats instead
            local formatters = {
                fish_indent = {
                    filetypes = { "fish" },
                },
                gofmt = {
                    filetypes = { "go" },
                    skip_for_lsp = "gopls",
                },
                -- only in repos configured for prettier, otherwise oxfmt. see utils/tool_pairs
                prettierd = require("utils.tool_pairs").conform("prettierd"),
                -- conform passes only indent from buffer, or nothing when repo has .editorconfig
                shfmt = {
                    filetypes = {
                        "bash",
                        "sh",
                    },
                    skip_for_lsp = "bashls",
                },
                stylua = {
                    filetypes = {
                        "lua",
                        "luau",
                    },
                    prepend_args = {
                        "--indent-type",
                        "spaces",
                    },
                },
                -- terraform-ls is not installed everywhere but terraform is
                terraform_fmt = {
                    filetypes = {
                        "hcl",
                        "terraform",
                    },
                },
            }

            -- conform maps the other way around
            local formatters_by_ft = {}
            for name, formatter in pairs(formatters) do
                for _, ft in ipairs(formatter.filetypes) do
                    formatters_by_ft[ft] = formatters_by_ft[ft] or {}
                    table.insert(formatters_by_ft[ft], name)
                end
                formatter.filetypes = nil
                if formatter.skip_for_lsp then
                    local lsp = formatter.skip_for_lsp
                    formatter.condition = function(_, ctx)
                        return #vim.lsp.get_clients({ bufnr = ctx.buf, name = lsp }) == 0
                    end
                    formatter.skip_for_lsp = nil
                end
            end

            return {
                formatters_by_ft = formatters_by_ft,
                formatters = formatters,
                default_format_opts = {
                    -- language servers which are already running format filetypes without a formatter above.
                    -- tsc formatting is disabled in lsp.lua when oxfmt is installed
                    lsp_format = "fallback",
                },
                format_on_save = function(bufnr)
                    if vim.b[bufnr].format_on_save ~= false then
                        return {}
                    end
                end,
            }
        end,
    },
}
