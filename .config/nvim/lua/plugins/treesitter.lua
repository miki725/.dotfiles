return function(use)
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        requires = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-refactor",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                -- built-in modules
                highlight = {
                    enable = true,
                    use_languagetree = true,
                    disable = {},
                },
                indent = {
                    enable = true,
                    disable = {},
                },
                autopairs = {
                    enable = true,
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                },

                -- additinal plugins
                refactor = {
                    highlight_definitions = {
                        enable = true,
                    },
                    highlight_current_scope = {
                        enable = false,
                    },
                },
                textobjects = {
                    enable = true,
                    select = {
                        lookahead = true,
                        enable = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                },
                ensure_installed = "maintained",
            })
        end,
    })
    use({
        "romgrk/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                patterns = {
                    default = {
                        "class",
                        "function",
                        "method",
                    },
                    terraform = {
                        "block",
                    },
                },
            })
        end,
    })
    use({
        "nvim-treesitter/playground",
        cmd = {
            "TSPlaygroundToggle",
        },
    })
end
