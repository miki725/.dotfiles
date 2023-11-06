return {
    {
        "ludovicchabant/vim-gutentags",
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
            vim.g.gutentags_file_list_command = "fd --strip-cwd-prefix"
            vim.g.gutentags_project_root = { ".github" }
        end,
    },
}
