-- Override global git insteadOf (ssh) so lazy.nvim plugin installs use HTTPS.
-- GIT_CONFIG_COUNT env vars apply at command-level priority, shadowing global config.
vim.env.GIT_CONFIG_COUNT = "1"
vim.env.GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf"
vim.env.GIT_CONFIG_VALUE_0 = "https://github.com/"

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
