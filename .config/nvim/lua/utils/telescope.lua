local lazy = require("lazy")

local M = {}

local is_enabled = function(value)
    if value == nil then
        return true
    end
    if type(value) == "function" then
        return value()
    end
    return value
end

local default_opts = { order = 1 }

M.registered = {}

M.register = function(plugin)
    if is_enabled(plugin.enabled) and is_enabled(plugin.cond) then
        if not plugin.extensions then
            local name = plugin.main or plugin.name
            if name then
                plugin.extensions = { [name] = {} }
            else
                vim.notify(plugin[1] .. " needs to define telescope extensions or main", vim.log.levels.ERROR)
                return
            end
        end
        for name, opts in pairs(plugin.extensions) do
            opts = vim.tbl_deep_extend("force", default_opts, opts or {})
            table.insert(M.registered, {
                name = name,
                opts = opts,
                plugin = plugin,
            })
        end
        table.sort(M.registered, function(left, right)
            return left.opts.order < right.opts.order
        end)
    end
    return plugin
end

M.opts = function(opts)
    return function()
        local extensions = {}
        for _, extension in pairs(M.registered) do
            extensions[extension.name] = extension.opts
        end
        opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, extensions)
        return opts
    end
end

M.config = function()
    return function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        for _, extension in pairs(M.registered) do
            lazy.load({ plugins = extension.plugin.name }) -- lazy load plugin
            telescope.load_extension(extension.name)
        end
    end
end

return M
