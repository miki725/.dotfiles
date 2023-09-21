vim.cmd([[
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
]])

return function(use)
    use({
        "ojroques/vim-oscyank",
        cmd = "OSCYankRegister",
        config = function()
            if vim.env.SSH_CONNECTION ~= nil then
                vim.g.oscyank_term = "default"
            end
        end,
    })
end
