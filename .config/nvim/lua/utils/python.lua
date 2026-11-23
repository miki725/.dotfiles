local M = {}

-- module level names a string in __all__ can refer to
local defs_query = [[
    (module [
        (function_definition name: (identifier) @name)
        (class_definition name: (identifier) @name)
        (decorated_definition definition: [
            (function_definition name: (identifier) @name)
            (class_definition name: (identifier) @name)])
        (expression_statement (assignment left: (identifier) @name))
        (import_from_statement name: [
            (dotted_name (identifier) @name .)
            (aliased_import alias: (identifier) @name)])
        (import_statement name: (aliased_import alias: (identifier) @name))
    ])
]]

-- name of the __all__ entry at position, if any
local dunder_all_entry = function(bufnr, row, col)
    local node = vim.treesitter.get_node({ bufnr = bufnr, pos = { row, col }, ignore_injections = true })
    while node and node:type() ~= "string" do
        node = node:parent()
    end
    if not node then
        return nil
    end
    local assignment = node:parent() and node:parent():parent()
    if not assignment or assignment:type() ~= "assignment" then
        return nil
    end
    local left = assignment:field("left")[1]
    if not left or vim.treesitter.get_node_text(left, bufnr) ~= "__all__" then
        return nil
    end
    for child in node:iter_children() do
        if child:type() == "string_content" then
            return vim.treesitter.get_node_text(child, bufnr)
        end
    end
end

-- first module level definition of name. captures come in document order
local find_def = function(bufnr, root, name)
    local query = vim.treesitter.query.parse("python", defs_query)
    for _, node in query:iter_captures(root, bufnr) do
        if vim.treesitter.get_node_text(node, bufnr) == name then
            return node
        end
    end
end

-- language servers dont resolve __all__ strings so utils/ts_lsp finds their definitions
M.dunder_all_definition = function(bufnr, root, row, col)
    local name = dunder_all_entry(bufnr, row, col)
    return name and find_def(bufnr, root, name)
end

return M
