local snacks_utils = require("utils.snacks")

return {
    snacks_utils.register({
        "ludovicchabant/vim-gutentags",
        -- keys would otherwise make it lazy and tags would not be generated on startup
        lazy = false,
        pickers = require("pickers.ctags"),
        keys = {
            {
                "<C-t>",
                function()
                    Snacks.picker.ctags_buffer()
                end,
                desc = "Picker: Search buffer tags",
            },
            {
                "<A-t>",
                function()
                    -- streams tag files with the snacks fork. see TODO in plugins/snacks.lua
                    Snacks.picker.tags()
                end,
                desc = "Picker: Search tags",
            },
        },
        cond = function()
            if vim.fn.executable("fd") == 0 then
                return false
            end
            if vim.fn.executable("ctags") == 0 then
                return false
            end
            return true
        end,
        init = function()
            vim.g.gutentags_define_advanced_commands = true
            -- repos can exclude paths from tags only with a gitignore-style .ctagsignore
            vim.g.gutentags_file_list_command = {
                markers = {
                    [".ctagsignore"] = "fd --strip-cwd-prefix --ignore-file .ctagsignore",
                },
                default = "fd --strip-cwd-prefix",
            }
            vim.g.gutentags_project_root = { ".github" }
            -- line numbers let pickers jump and preview without re-searching the pattern
            vim.g.gutentags_ctags_extra_args = { "--fields=+n" }
        end,
    }),
}
