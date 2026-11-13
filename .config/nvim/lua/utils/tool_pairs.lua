local M = {}

-- newer tools (oxc, ty) are used by default but repos configured for older tools
-- keep using them so saves and diagnostics match their CI.
-- each pair defines both sides together:
--   config: files which configure that side. { file = name, contains = pattern } also matches file content.
--           nearest config to the buffer wins so monorepo packages can differ
--   binary: legacy side is only used when installed, otherwise new side is used everywhere
--   lsp/opts: language server name and extra vim.lsp.config opts
--   conform/filetypes: conform formatter name and function returning filetypes it formats
--   root_markers: lsp root when no config is found, falling back to file dir
M.pairs = {
    -- js/ts/json/yaml/css/markdown formatting
    {
        root_markers = {
            "package.json",
            ".git",
        },
        legacy = {
            binary = "prettierd",
            config = {
                ".prettierrc",
                ".prettierrc.json",
                ".prettierrc.json5",
                ".prettierrc.yaml",
                ".prettierrc.yml",
                ".prettierrc.toml",
                ".prettierrc.js",
                ".prettierrc.cjs",
                ".prettierrc.mjs",
                ".prettierrc.ts",
                "prettier.config.js",
                "prettier.config.cjs",
                "prettier.config.mjs",
                "prettier.config.ts",
            },
            conform = "prettierd",
            -- same as oxfmt except toml which prettier cant format
            filetypes = function()
                return vim.tbl_filter(function(ft)
                    return ft ~= "toml"
                end, vim.lsp.config.oxfmt.filetypes)
            end,
        },
        new = {
            lsp = "oxfmt",
            binary = "oxfmt",
            config = {
                ".oxfmtrc.json",
                ".oxfmtrc.jsonc",
                "oxfmt.config.ts",
            },
        },
    },
    -- js/ts linting
    {
        root_markers = {
            "package.json",
            ".git",
        },
        legacy = {
            lsp = "eslint",
            binary = "vscode-eslint-language-server",
            -- only lint. fixes are available via code actions or :LspEslintFixAll
            opts = {
                settings = {
                    format = false,
                },
            },
            config = {
                ".eslintrc",
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.json",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                "eslint.config.js",
                "eslint.config.mjs",
                "eslint.config.cjs",
                "eslint.config.ts",
                "eslint.config.mts",
                "eslint.config.cts",
            },
        },
        new = {
            lsp = "oxlint",
            binary = "oxlint",
            config = {
                ".oxlintrc.json",
                ".oxlintrc.jsonc",
                "oxlint.config.ts",
            },
        },
    },
    -- python type checking
    {
        root_markers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            ".git",
        },
        legacy = {
            lsp = "basedpyright", -- drop-in pyright replacement with stricter defaults
            binary = "basedpyright-langserver",
            config = {
                "pyrightconfig.json",
                {
                    file = "pyproject.toml",
                    contains = "%[tool%.pyright%]",
                },
                {
                    file = "pyproject.toml",
                    contains = "%[tool%.basedpyright%]",
                },
            },
        },
        new = {
            lsp = "ty",
            binary = "ty",
            config = {
                "ty.toml",
                {
                    file = "pyproject.toml",
                    contains = "%[tool%.ty%]",
                },
            },
        },
    },
}

-- nearest dir with any of the markers
local find_config = function(bufnr, markers)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then
        return nil
    end
    local found = vim.fs.find(function(name, path)
        for _, marker in ipairs(markers) do
            if type(marker) == "string" and name == marker then
                return true
            end
            if type(marker) == "table" and name == marker.file then
                local file = io.open(vim.fs.joinpath(path, name))
                local content = file and file:read("*a") or ""
                if file then
                    file:close()
                end
                if content:find(marker.contains) then
                    return true
                end
            end
        end
        return false
    end, { path = vim.fs.dirname(fname), upward = true })[1]
    return found and vim.fs.dirname(found)
end

local uses_legacy = function(bufnr, pair)
    if vim.fn.executable(pair.legacy.binary) == 0 then
        return false
    end
    local legacy = find_config(bufnr, pair.legacy.config)
    if not legacy then
        return false
    end
    local new = find_config(bufnr, pair.new.config)
    return not new or #legacy > #new
end

-- whether given side of the pair should run for the buffer
local is_active = function(bufnr, pair, side)
    return uses_legacy(bufnr, pair) == (side == "legacy")
end

-- lspconfig root_dir which only attaches when side is active
local root_dir = function(pair, side)
    local markers = vim.tbl_filter(function(marker)
        return type(marker) == "string"
    end, pair[side].config)
    vim.list_extend(markers, pair.root_markers)
    return function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if fname == "" or not is_active(bufnr, pair, side) then
            return
        end
        on_dir(vim.fs.root(bufnr, markers) or vim.fs.dirname(fname))
    end
end

-- pair and side where given field (lsp or conform) is the tool name
local find = function(field, name)
    for _, pair in ipairs(M.pairs) do
        for _, side in ipairs({ "legacy", "new" }) do
            if pair[side][field] == name then
                return pair, side
            end
        end
    end
    error(("no tool pair for %s %s"):format(field, name))
end

-- vim.lsp.config opts for one side of a pair which only attach when that side is active.
-- binary is used in lsp.lua to check server is installed
M.lsp = function(name)
    local pair, side = find("lsp", name)
    local tool = pair[side]
    return vim.tbl_extend("force", tool.opts or {}, {
        binary = tool.binary,
        root_dir = root_dir(pair, side),
    })
end

-- conform formatter for one side of a pair which only runs when that side is active
-- and filetypes it formats
M.conform = function(name)
    local pair, side = find("conform", name)
    return {
        filetypes = pair[side].filetypes(),
        condition = function(_, ctx)
            return is_active(ctx.buf, pair, side)
        end,
    }
end

return M
