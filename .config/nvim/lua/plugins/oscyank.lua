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
        end,
        opts = {
            max_length = 0, -- Maximum length of selection (0 for no limit)
            silent = false, -- Disable message on successful copy
            trim = false, -- Trim surrounding whitespaces before copy
        },
    },
}
