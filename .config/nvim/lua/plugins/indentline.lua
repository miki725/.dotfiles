vim.g.indentLine_concealcursor = "inc"
vim.g.indentLine_conceallevel = 2

-- by default it is hiding some characters such as quotes
-- in json file keys which is probably great but super confusing
vim.cmd([[
autocmd FileType json let g:indentLine_conceallevel=0
]])

return function(use)
    -- shows indent indicators
    use("Yggdroot/indentLine")
end
