vim.cmd([[
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
]])

return function(use)
    use({
        "ojroques/vim-oscyank",
        cmd = "OSCYankReg",
    })
end
