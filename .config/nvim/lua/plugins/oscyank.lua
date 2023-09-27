return {
    {
        "ojroques/nvim-osc52",
        event = {
            "TextYankPost",
        },
        init = function()
            vim.api.nvim_create_autocmd("TextYankPost", {
                callback = function()
                    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
                        require("osc52").copy_register('"')
                    end
                end,
            })

            local function copy(lines, _)
                require("osc52").copy(table.concat(lines, "\n"))
            end

            local function paste()
                return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
            end

            -- osc should automatically copy clipboard registers
            vim.g.clipboard = {
                name = "osc52",
                copy = { ["+"] = copy, ["*"] = copy },
                paste = { ["+"] = paste, ["*"] = paste },
            }
        end,
        opts = {
            max_length = 0, -- Maximum length of selection (0 for no limit)
            silent = false, -- Disable message on successful copy
            trim = false, -- Trim surrounding whitespaces before copy
        },
    },
}
