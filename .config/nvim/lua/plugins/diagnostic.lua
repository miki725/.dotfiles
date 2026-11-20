return {
    -- diagnostics for cursor line as inline popup at end of line
    -- without covering other floats like hover or signature help
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        init = function()
            -- plugin only draws inline popup so sign column icons are configured here.
            -- escapes as literal nerd font glyphs get stripped by some editors/tools
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "\u{f057} ", -- 
                        [vim.diagnostic.severity.WARN] = "\u{f071} ", -- 
                        [vim.diagnostic.severity.INFO] = "\u{f05a} ", -- 
                        [vim.diagnostic.severity.HINT] = "\u{f0335}", -- 󰌵
                    },
                },
                -- errors win over warnings in sign column
                severity_sort = true,
            })
        end,
        opts = {
            options = {
                show_source = {
                    enabled = true,
                },
            },
        },
        config = function(_, opts)
            require("tiny-inline-diagnostic").setup(opts)

            -- hides signs, underlines and inline popup for current buffer
            Snacks.toggle
                .new({
                    id = "diagnostics",
                    name = "diagnostics for buffer",
                    get = function()
                        return vim.diagnostic.is_enabled({ bufnr = 0 })
                    end,
                    set = function(state)
                        vim.diagnostic.enable(state, { bufnr = 0 })
                        -- redraws inline popup which otherwise lingers until cursor moves
                        require("tiny-inline-diagnostic").enable()
                    end,
                })
                :map("<leader>td")

            -- inline popup is virtual text so it cant be selected. copies its messages instead.
            -- for a selectable popup press <C-w>d twice: first opens float, second enters it
            vim.keymap.set("n", "<leader>cd", function()
                local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
                local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
                if #diagnostics == 0 then
                    vim.notify("No diagnostics on line", vim.log.levels.WARN)
                    return
                end
                local lines = vim.tbl_map(function(d)
                    local source = d.source and (d.source .. ": ") or ""
                    local code = d.code and (" [" .. d.code .. "]") or ""
                    return source .. d.message .. code
                end, diagnostics)
                vim.fn.setreg("+", table.concat(lines, "\n"))
                vim.notify("Copied " .. #lines .. " diagnostic(s)")
            end, { desc = "Copy diagnostics on line" })
        end,
    },
}
