-- Bypass global git ssh-insteadOf so lazy.nvim plugin installs use HTTPS.
-- gitconfig prepends an identity insteadOf before including ~/.gitconfig;
-- git picks the first rule on prefix-length ties, so HTTPS wins over SSH.
vim.env.GIT_CONFIG_GLOBAL = vim.fn.stdpath("config") .. "/gitconfig"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    -- checkout the exact commit from the lockfile so lazy.nvim itself is pinned
    local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
    local f = io.open(lockfile, "r")
    if f then
        local ok, lock = pcall(vim.json.decode, f:read("*a"))
        f:close()
        if ok and lock["lazy.nvim"] then
            vim.fn.system({ "git", "-C", lazypath, "checkout", lock["lazy.nvim"].commit })
        end
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    dev = {
        path = "~/Code/miki725",
    },
})

-- On startup, if any installed plugin's commit differs from the lockfile,
-- restore all plugins so machines stay in sync when the lockfile is updated elsewhere.
vim.defer_fn(function()
    local lockfile_path = vim.fn.stdpath("config") .. "/lazy-lock.json"
    local f = io.open(lockfile_path, "r")
    if not f then return end
    local ok, lock = pcall(vim.json.decode, f:read("*a"))
    f:close()
    if not ok then return end

    local needs_restore = false
    local Config = require("lazy.core.config")
    local Git = require("lazy.manage.git")
    for name, plugin in pairs(Config.plugins) do
        if plugin._.installed and not plugin._.is_local then
            local entry = lock[name]
            if entry and not Git.eq(Git.info(plugin.dir) or {}, entry) then
                needs_restore = true
                break
            end
        end
    end

    if needs_restore then
        vim.notify("Plugins out of sync with lockfile — restoring", vim.log.levels.INFO)
        require("lazy").restore()
    end
end, 0)
