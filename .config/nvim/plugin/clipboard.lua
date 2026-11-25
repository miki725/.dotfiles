-- yank/put use the system clipboard. only "+ as on macOS "* is the same clipboard
-- and over ssh syncing both would send every copy twice
-- https://medium.com/swlh/8-vim-tricks-that-will-take-you-from-beginner-to-expert-817ff4870245
vim.opt.clipboard = { "unnamedplus" }

-- Native OSC52 clipboard for SSH sessions. tmux handles OSC52 itself (not passthrough):
-- set-clipboard forwards copies and get-clipboard request forwards pastes to the terminal,
-- through every tmux when nested. ghostty answers reads with clipboard-read = allow.
-- see .docs/CLIPBOARD.md
local is_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CLIENT ~= nil
if vim.fn.has("gui_running") == 0 and is_ssh then
    local osc52 = require("vim.ui.clipboard.osc52")

    -- some terminals (e.g. wezterm) never answer clipboard reads and nvim would wait 10s on
    -- every paste. so ask once on start and only read the terminal clipboard once it answered
    local answers = false
    vim.api.nvim_create_autocmd("TermResponse", {
        callback = function(ev)
            if ev.data.sequence:match("^\027%]52;") then
                answers = true
                return true -- deletes the autocmd
            end
        end,
    })
    vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
            vim.api.nvim_ui_send("\027]52;c;?\027\\")
        end,
    })

    -- otherwise paste the newest tmux buffer, which has the latest copy from tmux and from nvim
    -- (set-clipboard makes buffers of OSC52 copies), or without tmux nvim's unnamed register.
    -- cmd+v always pastes the mac clipboard
    local function paste(reg)
        local read = osc52.paste(reg)
        return function()
            if answers then
                return read()
            end
            local text = vim.env.TMUX and vim.fn.system({ "tmux", "save-buffer", "-" })
            if not text or vim.v.shell_error ~= 0 then
                return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
            end
            -- buffers ending with a newline are whole lines (e.g. yy in nvim)
            local lines = vim.split(text, "\n", { plain = true })
            if text:sub(-1) == "\n" then
                table.remove(lines)
                return { lines, "V" }
            end
            return { lines, "v" }
        end
    end

    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = osc52.copy("+"),
            ["*"] = osc52.copy("*"),
        },
        paste = {
            ["+"] = paste("+"),
            ["*"] = paste("*"),
        },
    }
end

-- https://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
-- copy current file name (relative/absolute) to system clipboard

local names = {
    cf = { expand = "%", desc = "Copy relative filepath [clipboard]" },
    cF = { expand = "%:p", desc = "Copy absolute filepath [clipboard]" },
    ct = { expand = "%:t", desc = "Copy filename [clipboard]" },
    cT = { expand = "%:p:h", desc = "Copy folder [clipboard]" },
}

for key, lookup in pairs(names) do
    vim.keymap.set({ "n", "x" }, "<leader>" .. key, function()
        local value = vim.fn.expand(lookup.expand)
        vim.fn.setreg("+", value)
        -- setreg("+") does not set the unnamed register which p pastes when the clipboard
        -- cannot be read (e.g. over ssh in wezterm without tmux). setting it does not copy again
        vim.fn.setreg('"', value)
        print(value)
    end, { desc = lookup.desc })
end

-- briefly highlight yanked text (e.g. yaw, yap)
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.hl.on_yank({ higroup = "Search", timeout = 250 })
    end,
})
