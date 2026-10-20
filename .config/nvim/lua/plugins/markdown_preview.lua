return {
    {
        "selimacerbas/mdkite.nvim",
        dependencies = { "selimacerbas/kitehost.nvim" },
        ft = { "markdown" },
        -- also load on the old markdown-preview.nvim names kept as habit aliases
        cmd = { "MdKite", "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewRefresh" },
        config = function()
            local mdkite = require("mdkite")

            mdkite.setup({
                -- mdkite bakes the theme in at render time (no "system"
                -- value); default to light and use the in-page toggle for dark
                default_theme = "light",
                -- a server and browser tab per Neovim instance on an
                -- OS-assigned port, so separate Neovims can preview
                -- different files side by side
                instance_mode = "multi",
                -- keep the header (connection dot + status) pinned on scroll
                custom_css = vim.fn.stdpath("config") .. "/assets/mdkite.css",
                -- bind all interfaces so the preview is reachable when
                -- editing over SSH; mdkite gates a network bind with a
                -- per-session token, so peers cannot read the buffer
                -- without the tokenized URL
                host = "0.0.0.0",
                -- over SSH a browser would open on the remote server, so only
                -- print the tokenized URL to open yourself; locally open it
                open_browser = vim.env.SSH_CONNECTION == nil and vim.env.SSH_TTY == nil,
                hooks = {
                    on_start = function(url)
                        -- echo to the command line (and :messages) so the
                        -- URL stays visible instead of flashing as a toast
                        vim.api.nvim_echo({ { "mdkite: " .. url } }, true, {})
                    end,
                },
            })

            -- keep the old markdown-preview.nvim command names working out of
            -- habit, but call mdkite directly so they skip its deprecation
            -- warning (mdkite's own aliases warn and are dropped in 3.0.0).
            -- These override mdkite's forwarded commands, defined on load.
            for name, sub in pairs({
                MarkdownPreview = "start",
                MarkdownPreviewStop = "stop",
                MarkdownPreviewRefresh = "refresh",
            }) do
                vim.api.nvim_create_user_command(name, function()
                    mdkite[sub]()
                end, { desc = "mdkite: " .. sub .. " (alias)" })
            end
        end,
    },
}
