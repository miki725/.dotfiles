vim.o.winborder = "rounded"

-- for GUI apps like neovide
vim.o.guifont = "Hack Nerd Font"

local pwd = vim.api.nvim_exec2("pwd", { output = true }).output
local is_gui = vim.fn.has("gui_running") > 0
if pwd == "/" and is_gui then
    vim.cmd.cd(vim.fn.expand("$HOME"))
end

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
    vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
    -- cmd+v pastes the system clipboard in every mode like a terminal paste does
    vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<D-v>", function()
        vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
    end, { desc = "Paste system clipboard [neovide]" })

    -- files dragged into neovide open with cwd ~ so cd into the first file's git repo
    -- unless the file is already under cwd; later files leave cwd alone.
    -- dragged files also open in a new tab next to the startup dashboard so close the dashboard tab
    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("neovide_git_root_cwd", {}),
        callback = function(args)
            if vim.bo[args.buf].buftype ~= "" then
                return
            end
            local file = vim.api.nvim_buf_get_name(args.buf)
            if file == "" then
                return
            end
            local cwd = vim.fn.getcwd()
            if cwd == vim.env.HOME or not vim.fs.relpath(cwd, file) then
                local root = vim.fs.root(args.buf, ".git")
                if root and root ~= cwd then
                    vim.cmd.cd(root)
                end
            end
            vim.schedule(function()
                for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
                    local wins = vim.api.nvim_tabpage_list_wins(tab)
                    local only_dashboard = vim.iter(wins):all(function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_dashboard"
                    end)
                    if only_dashboard and #vim.api.nvim_list_tabpages() > 1 then
                        vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(tab))
                    end
                end
            end)
            -- returning true deletes the autocmd
            return true
        end,
    })
end
