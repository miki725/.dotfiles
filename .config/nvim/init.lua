-- Bypass global git ssh-insteadOf so lazy.nvim plugin installs use HTTPS.
-- gitconfig prepends an identity insteadOf before including ~/.gitconfig;
-- git picks the first rule on prefix-length ties, so HTTPS wins over SSH.
vim.env.GIT_CONFIG_GLOBAL = vim.fn.stdpath("config") .. "/gitconfig"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

local Lock = require("lazy.manage.lock")

-- whether any installed plugin is checked out at a different commit than the lockfile
local function out_of_sync()
    local Config = require("lazy.core.config")
    local Git = require("lazy.manage.git")
    for _, plugin in pairs(Config.plugins) do
        local entry = plugin._.installed and not plugin._.is_local and Lock.get(plugin)
        if entry and not Git.eq(Git.info(plugin.dir) or {}, entry) then
            return true
        end
    end
    return false
end

-- lazy rewrites the lockfile from on-disk commits after every install/clean/restore.
-- When a pulled lockfile adds plugins, startup installs them and would record the
-- stale commits of the rest, so skip those writes until plugins match the lockfile.
-- :Lazy update (and sync) always write.
local write_lock = Lock.update
local updating = false
vim.api.nvim_create_autocmd("User", { pattern = "LazyUpdatePre", callback = function() updating = true end })
---@diagnostic disable-next-line: duplicate-set-field
Lock.update = function()
    if updating or not out_of_sync() then
        write_lock()
    end
end

require("lazy").setup("plugins", {
    -- no plugins when editing gopass secrets as many persist file paths or contents
    defaults = {
        cond = not require("gopass").active,
    },
    dev = {
        path = "~/Code/miki725",
    },
})

-- On startup, if any installed plugin's commit differs from the lockfile,
-- restore all plugins so machines stay in sync when the lockfile is updated elsewhere.
vim.defer_fn(function()
    if require("gopass").active then return end
    if out_of_sync() then
        vim.notify("Plugins out of sync with lockfile — restoring", vim.log.levels.INFO)
        require("lazy").restore()
    end
end, 0)
