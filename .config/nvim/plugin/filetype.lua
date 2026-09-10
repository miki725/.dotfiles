vim.filetype.add({
    extension = {
        nc = "c",
        c42spec = "con4m",
        c4m = "con4m",
        ipynb = "ipynb",
        r2py = "python",
        -- native detect.tf reads content and usually returns terraform, but force it
        tf = "terraform",
        -- native maps tfvars to "terraform-vars" which breaks treesitter/LSP
        tfvars = "terraform",
    },
    pattern = {
        -- Jinja2 templates: match the base extension before .j2
        [".*%.ini%.j2$"] = "dosini",
        [".*%.sh%.j2$"] = "sh",
        [".*%.toml%.j2$"] = "toml",
        [".*%.ya?ml%.j2$"] = "yaml",
        -- .envrc is native; .envrc.local etc. are not
        ["%.envrc%..*$"] = "sh",
        -- .Makefile, .Makefile.local etc. are not native
        ["%.Makefile[^/]*$"] = "make",
    },
})
