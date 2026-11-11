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

M.sources = {}

-- sources created by lazy_source. they merge in a config hook so overrides need reapplying after
local lazy_sources = setmetatable({}, { __mode = "k" })

-- registers plugin.pickers as global snacks picker sources.
-- sources are plain config so plugins still lazy load on first require inside a finder
M.register = function(plugin)
    if is_enabled(plugin.enabled) and is_enabled(plugin.cond) then
        for name, source in pairs(plugin.pickers or {}) do
            M.sources[name] = source
        end
    end
    plugin.pickers = nil
    return plugin
end

-- source which is defined by a lazy loaded plugin module
M.lazy_source = function(get)
    local source = {
        config = function(opts)
            -- copy as fix_keys modifies in place
            local source = vim.deepcopy(get())
            -- snacks moves confirm into actions and normalizes keys (<c-x> -> <C-X>) before running config hooks
            if source.confirm then
                source = vim.tbl_deep_extend("force", source, { actions = { confirm = source.confirm } })
            end
            require("snacks.picker.config").fix_keys(source)
            opts = vim.tbl_deep_extend("force", opts, source)
            -- snacks already ran config hooks so run the source's own
            return source.config and source.config(opts) or opts
        end,
    }
    lazy_sources[source] = true
    return source
end

-- merges registered sources into snacks opts. overrides in opts.picker.sources win over registered sources
M.opts = function(opts)
    return function()
        opts.picker = opts.picker or {}
        local overrides = opts.picker.sources or {}
        opts.picker.sources = vim.tbl_deep_extend("force", M.sources, overrides)
        for name, source in pairs(M.sources) do
            if lazy_sources[source] and overrides[name] then
                opts.picker.sources[name].config = function(o)
                    local override = require("snacks.picker.config").fix_keys(vim.deepcopy(overrides[name]))
                    return vim.tbl_deep_extend("force", source.config(o), override)
                end
            end
        end
        return opts
    end
end

return M
