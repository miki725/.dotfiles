-- templates rendered into shell scripts
vim.filetype.add({
    pattern = {
        [".*%.sh%.tpl"] = "sh",
    },
})
