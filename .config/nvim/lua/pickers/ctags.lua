-- snacks has lsp_symbols and treesitter for the current buffer but nothing for ctags
local M = {}

local parse = function(line)
    -- skip !_TAG_ pseudo-tags
    if line:byte(1) == 33 then
        return
    end
    local name, path, rest = line:match("^([^\t]+)\t([^\t]+)\t(.*)$")
    if not name then
        return
    end
    local lnum = tonumber(rest:match("\tline:(%d+)") or rest:match('^(%d+);"'))
    return {
        text = name .. " " .. path,
        name = name,
        kind = rest:match(';"\t(%a)\t') or rest:match(';"\t(%a)$'),
        file = path,
        pos = lnum and { lnum, 0 } or nil,
    }
end

local format = function(item, picker)
    local ret = {
        { item.name, "SnacksPickerLabel" },
        { " " },
        { item.kind or " ", "SnacksPickerComment" },
        { " " },
    }
    vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
    return ret
end

M.ctags_buffer = {
    title = "Buffer Tags",
    preview = "file",
    format = format,
    -- keep file order instead of sorting by name
    sort = { fields = { "score:desc", "idx" } },
    finder = function(_, ctx)
        local file = vim.api.nvim_buf_get_name(ctx.filter.current_buf)
        if file == "" or vim.fn.filereadable(file) == 0 then
            return {}
        end
        local out = vim.system({ "ctags", "--fields=+n", "--sort=no", "-f", "-", file }, { text = true }):wait()
        local items = {}
        for line in vim.gsplit(out.stdout or "", "\n", { plain = true, trimempty = true }) do
            table.insert(items, parse(line))
        end
        table.sort(items, function(a, b)
            return (a.pos and a.pos[1] or 0) < (b.pos and b.pos[1] or 0)
        end)
        return items
    end,
}

return M
