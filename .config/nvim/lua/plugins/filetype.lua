return {
    {
        "nathom/filetype.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            vim.g.did_load_filetypes = 1
        end,
        opts = {
            overrides = {
                literal = {
                    COMMIT_EDITMSG = "gitcommit",
                    MERGE_MSG = "gitcommit",
                },
                extensions = {
                    ["ini.j2"] = "dosini",
                    ["r2py"] = "python",
                    ["sh"] = "sh",
                    ["sh.j2"] = "sh",
                    ["tf"] = "terraform", -- default is tf which doesnt match treesitter/LSP
                    ["toml.j2"] = "toml",
                    ["yml.j2"] = "yaml",
                },
                star_sets = {
                    [".envrc*"] = "sh",
                    ["Dockerfile.*"] = "dockerfile",
                    [".Makefile*"] = "make",
                },
            },
        },
        main = "filetype",
        config = function(plugin, opts)
            local p = require(plugin.main)
            p.setup(opts)

            -- the autogroup is defined in vim so we redefine in lua
            -- as filetype.vim is not inside plugin/ folder so is not auto-sourced
            local group = vim.api.nvim_create_augroup("FileTypeDetect", { clear = true })
            vim.api.nvim_clear_autocmds({ group = group })
            vim.api.nvim_create_autocmd({
                "BufNewFile",
                "BufRead",
            }, {
                group = group,
                callback = p.resolve,
            })
        end,
    },
}