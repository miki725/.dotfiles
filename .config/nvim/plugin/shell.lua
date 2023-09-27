-- in :terminal use fish by default
if vim.fn.executable("fish") > 0 then
    vim.o.shell = "fish"
end
