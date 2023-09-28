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
                literal = {},
                extensions = {
                    ["ini.j2"] = "dosini",
                    ["r2py"] = "python",
                    ["sh"] = "sh",
                    ["sh.j2"] = "sh",
                    ["toml.j2"] = "toml",
                    ["yml.j2"] = "yaml",
                },
                star_sets = {
                    [".envrc*"] = "sh",
                    ["Dockerfile.*"] = "dockerfile",
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
