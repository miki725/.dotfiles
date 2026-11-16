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
            end, { desc = "List installed treesitter parsers" })

            -- highlighting, plus indent/folds when the language has queries for them.
            -- buffers without a parser are left alone
            local function attach(buf, lang)
                if not pcall(vim.treesitter.start, buf, lang) then
                    return
                end
                -- markdown sets its own list-aware indentexpr in ftplugin/markdown.lua
                if vim.bo[buf].filetype ~= "markdown" and vim.treesitter.query.get(lang, "indents") then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
                if vim.treesitter.query.get(lang, "folds") then
                    vim.b[buf].treesitter_folds = true
                    local function set_folds(win)
                        vim.wo[win][0].foldmethod = "expr"
                        vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                        vim.wo[win][0].foldenable = false
                    end
                    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
                        set_folds(win)
                    end
                    -- buffers loaded in the background get folds once shown
                    vim.api.nvim_create_autocmd("BufWinEnter", {
                        group = vim.api.nvim_create_augroup("treesitter_folds_" .. buf, {}),
                        buffer = buf,
                        callback = function()
                            set_folds(0)
                        end,
                    })
                end
            end

            -- remaining languages are installed on-demand when a file is opened (see FileType autocmd below)
            require("nvim-treesitter").install({
                "bash",
                "c",
                "css",
                "gitcommit",
                "go",
                "graphql",
                "html",
                "javascript",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "terraform",
                "toml",
                "typescript",
                "yaml",
            })

            -- parsers that failed to install, not retried this session so open doesn't block again
            local failed = {}
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    -- filetype changed: undo folds attach() set up for the old filetype.
                    -- its BufWinEnter autocmd would keep setting them in new windows and
                    -- open windows keep them as window options. attach() below redoes both if supported
                    if vim.b[args.buf].treesitter_folds then
                        vim.b[args.buf].treesitter_folds = nil
                        pcall(vim.api.nvim_del_augroup_by_name, "treesitter_folds_" .. args.buf)
                        for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
                            vim.wo[win][0].foldmethod = vim.go.foldmethod
                            vim.wo[win][0].foldexpr = vim.go.foldexpr
                            vim.wo[win][0].foldenable = vim.go.foldenable
                        end
                    end
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang then
                        return
                    end
                    if
                        not vim.treesitter.language.add(lang)
                        and require("nvim-treesitter.parsers")[lang]
                        and not failed[lang]
                    then
                        vim.notify("Installing treesitter parser for " .. lang .. "...", vim.log.levels.INFO)
                        pcall(function()
                            require("nvim-treesitter").install({ lang }):wait(60000)
                        end)
                        failed[lang] = not vim.treesitter.language.add(lang) or nil
                    end
                    attach(args.buf, lang)
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
