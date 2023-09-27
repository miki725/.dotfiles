return {
    {
        "andrewferrier/wrapping.nvim",
        cmd = {
            "HardWrapMode",
            "SoftWrapMode",
            "ToggleWrapMode",
        },
        opts = {
            auto_set_mode_filetype_allowlist = {
                "asciidoc",
                "gitcommit",
                "latex",
                "mail",
                "markdown",
                "tex",
                "text",
            },
        },
    },
}
