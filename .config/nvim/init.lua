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
