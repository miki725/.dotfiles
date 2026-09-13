return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "main",
            },
        },
        config = function()
            require("nvim-treesitter").setup({})

            vim.api.nvim_create_user_command("TSInstalled", function()
                local files = vim.api.nvim_get_runtime_file("parser/*.so", true)
                local langs = vim.tbl_map(function(p)
                    return vim.fn.fnamemodify(p, ":t:r")
                end, files)
                table.sort(langs)
                print(table.concat(langs, "\n"))
            end, {})

            -- remaining languages are installed on-demand when a file is opened (see FileType autocmd below)
            require("nvim-treesitter").install({
                "lua",
                "python",
                "typescript",
                "javascript",
                "go",
                "bash",
                "c",
                "terraform",
                "graphql",
                "json",
                "yaml",
                "toml",
                "markdown",
                "markdown_inline",
                "css",
                "html",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                    local parsers = require("nvim-treesitter.parsers")
                    if lang and parsers[lang] and not vim.treesitter.language.add(lang, { silent = true }) then
                        vim.notify("Installing treesitter parser for " .. lang .. "...", vim.log.levels.INFO)
                        require("nvim-treesitter").install({ lang }):wait(60000)
                    end
                    pcall(vim.treesitter.start)
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    vim.wo[0][0].foldmethod = "expr"
                    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo[0][0].foldenable = false
                end,
            })

            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move = { set_jumps = true },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")

            local select_maps = {
                { "af", "@function.outer", "Select outer function [TS]" },
                { "if", "@function.inner", "Select inner function [TS]" },
                { "ac", "@class.outer",    "Select outer class [TS]"    },
                { "ic", "@class.inner",    "Select inner class [TS]"    },
            }
            for _, m in ipairs(select_maps) do
                vim.keymap.set({ "x", "o" }, m[1], function()
                    select.select_textobject(m[2], "textobjects")
                end, { desc = m[3] })
            end

            local move_maps = {
                { "]]", move.goto_next_start,     "@function.outer", "Next function start [TS]" },
                { "]f", move.goto_next_start,     "@function.outer", "Next function start [TS]" },
                { "]c", move.goto_next_start,     "@class.outer",    "Next class start [TS]"    },
                { "][", move.goto_next_end,       "@function.outer", "Next function end [TS]"   },
                { "]F", move.goto_next_end,       "@function.outer", "Next function end [TS]"   },
                { "]C", move.goto_next_end,       "@class.outer",    "Next class end [TS]"      },
                { "[[", move.goto_previous_start, "@function.outer", "Prev function start [TS]" },
                { "[f", move.goto_previous_start, "@function.outer", "Prev function start [TS]" },
                { "[c", move.goto_previous_start, "@class.outer",    "Prev class start [TS]"    },
                { "[]", move.goto_previous_end,   "@function.outer", "Prev function end [TS]"   },
                { "[F", move.goto_previous_end,   "@function.outer", "Prev function end [TS]"   },
                { "[C", move.goto_previous_end,   "@class.outer",    "Prev class end [TS]"      },
            }
            for _, m in ipairs(move_maps) do
                vim.keymap.set({ "n", "x", "o" }, m[1], function()
                    m[2](m[3], "textobjects")
                end, { desc = m[4] })
            end
        end,
    },
    -- TODO: add nvim-treesitter/nvim-treesitter-locals once implemented (replacement for nvim-treesitter-refactor)
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {},
    },
}
