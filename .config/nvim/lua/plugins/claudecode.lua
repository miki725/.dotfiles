-- claude runs in its own tmux pane and reaches the nvims in its window through a proxy
-- (~/.bin/claude-ide-proxy.py started by the claude fish function) so either can start
-- or restart first. nvim publishes its server in a pane option instead of ~/.claude/ide lock file
local option = "@claude_ide"

local publish = function()
    local lockfile = require("claudecode.lockfile")
    local set = function(...)
        vim.fn.system({ "tmux", "set", "-p", "-t", vim.env.TMUX_PANE, ... })
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    lockfile.create = function(port, auth_token)
        set(option, port .. ":" .. auth_token)
        return true, option, auth_token
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    lockfile.remove = function()
        set("-u", option)
        return true
    end
end

return {
    {
        "coder/claudecode.nvim",
        event = "VeryLazy",
        -- outside tmux there is no window to pair with
        cond = vim.env.TMUX ~= nil,
        -- adds @mentions to the claude prompt. the selection/cursor is sent by itself
        keys = {
            { "<leader>a", nil, desc = "Claude" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "Send selection [Claude]" },
            -- \as{motion} like other operators e.g. \asap or \asaf (treesitter function)
            {
                "<leader>as",
                function()
                    vim.o.operatorfunc = [[{_ -> execute("'[,']ClaudeCodeSend", "")}]]
                    return "g@"
                end,
                expr = true,
                desc = "Send motion [Claude]",
            },
            { "<leader>ass", "<leader>as_", remap = true, desc = "Send line [Claude]" },
            { "<leader>af", "<leader>asaf", remap = true, desc = "Send function [Claude]" },
            { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", ft = "snacks_picker_list", desc = "Send file [Claude]" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Send buffer [Claude]" },
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff [Claude]" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff [Claude]" },
        },
        opts = {
            terminal = {
                provider = "none",
            },
        },
        config = function(_, opts)
            publish()
            require("claudecode").setup(opts)
        end,
    },
}
