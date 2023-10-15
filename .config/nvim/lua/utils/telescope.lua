local lazy = require("lazy")

local is_enabled = function(value)
    if value == nil then
        return true
    end
    if type(value) == "function" then
        return value()
    end
    return value
end

local extension_name = function(plugin)
    if vim.tbl_count(plugin.extension or {}) == 1 then
        return vim.tbl_keys(plugin.extension)[1]
    end
    return plugin.main or plugin.name
end

local extension_opts = function(plugin)
    local defaults = { order = 1 }
    local opts = (plugin.extension or {})[extension_name(plugin)] or {}
    return vim.tbl_deep_extend("force", defaults, opts)
end

local M = {}

M.registered = {}

M.register = function(plugin)
    if is_enabled(plugin.enabled) and is_enabled(plugin.cond) then
        table.insert(M.registered, plugin)
        table.sort(M.registered, function(left, right)
            return extension_opts(left).order < extension_opts(right).order
        end)
    end
    return plugin
end

M.opts = function(opts)
    return function()
        local extensions = {}
        for _, plugin in pairs(M.registered) do
            extensions[extension_name(plugin)] = extension_opts(plugin)
        end
        opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, extensions)
        return opts
    end
end

M.config = function()
    return function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        for _, plugin in pairs(M.registered) do
            lazy.load({ plugins = plugin.name }) -- lazy load plugin
            local key = extension_name(plugin)
            telescope.load_extension(key)
        end
    end
end

return M
