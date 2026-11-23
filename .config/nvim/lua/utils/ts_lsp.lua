local M = {}

-- in-process language server answering from treesitter where real servers dont, e.g. strings
-- in python __all__. it attaches next to them and nvim merges results from all servers
-- so gd, K and pickers work without custom mappings.
-- providers by treesitter language. definition(bufnr, root, row, col) returns a node or nil
M.providers = {
    python = {
        definition = function(...)
            return require("utils.python").dunder_all_definition(...)
        end,
    },
}

M.name = "ts_lsp"

-- byte columns so treesitter positions need no conversion
local capabilities = {
    positionEncoding = "utf-8",
    definitionProvider = true,
    hoverProvider = true,
}

-- definition node at request position from the buffer language provider
local find_definition = function(params)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
    local provider = lang and M.providers[lang]
    if not provider or not provider.definition then
        return nil
    end
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    if not ok or not parser then
        return nil
    end
    -- highlighting parses async so tree might not be ready yet
    local root = parser:parse()[1]:root()
    local node = provider.definition(bufnr, root, params.position.line, params.position.character)
    return node, bufnr
end

local location = function(uri, node)
    local start_row, start_col, end_row, end_col = node:range()
    return {
        uri = uri,
        range = {
            start = { line = start_row, character = start_col },
            ["end"] = { line = end_row, character = end_col },
        },
    }
end

-- hover from the other servers at the definition, first one with contents wins
local hover = function(node, bufnr, reply)
    local row, col = node:start()
    local clients = vim.tbl_filter(function(client)
        return client.name ~= M.name and client:supports_method("textDocument/hover", bufnr)
    end, vim.lsp.get_clients({ bufnr = bufnr }))
    local pending = #clients
    local done = false
    if pending == 0 then
        return reply(nil)
    end
    for _, client in ipairs(clients) do
        local params = {
            textDocument = vim.lsp.util.make_text_document_params(bufnr),
            position = { line = row, character = vim.lsp.util.character_offset(bufnr, row, col, client.offset_encoding) },
        }
        client:request("textDocument/hover", params, function(_, result)
            pending = pending - 1
            if done then
                return
            end
            if result and result.contents then
                done = true
                -- range points at the definition, not the hovered string
                result.range = nil
                reply(result)
            elseif pending == 0 then
                reply(nil)
            end
        end, bufnr)
    end
end

local handlers = {
    initialize = function(_, reply)
        reply({ capabilities = capabilities, serverInfo = { name = M.name } })
    end,
    ["textDocument/definition"] = function(params, reply)
        local node = find_definition(params)
        reply(node and location(params.textDocument.uri, node) or nil)
    end,
    ["textDocument/hover"] = function(params, reply)
        local node, bufnr = find_definition(params)
        if not node then
            return reply(nil)
        end
        hover(node, bufnr, reply)
    end,
}

-- vim.lsp.config cmd. dispatchers are unused as the server never sends notifications
M.cmd = function()
    local closing = false
    local request_id = 0
    return {
        request = function(method, params, callback, notify_reply_callback)
            request_id = request_id + 1
            local id = request_id
            -- replies are async like a real server so nvim registers the request first
            local reply = function(result)
                vim.schedule(function()
                    callback(nil, result)
                    if notify_reply_callback then
                        notify_reply_callback(id)
                    end
                end)
            end
            local handler = handlers[method]
            if handler then
                handler(params, reply)
            else
                reply(nil)
            end
            return true, id
        end,
        notify = function(method)
            if method == "exit" then
                closing = true
            end
            return true
        end,
        is_closing = function()
            return closing
        end,
        terminate = function()
            closing = true
        end,
    }
end

-- filetypes of all provider languages
M.filetypes = function()
    local filetypes = {}
    for lang in pairs(M.providers) do
        vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
    end
    return filetypes
end

return M
