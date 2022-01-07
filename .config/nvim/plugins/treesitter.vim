if PlugLoaded('nvim-treesitter')
lua << EOF

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    use_languagetree = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  refactor = {
    highlight_definitions = { enable = true },
  },
rainbow = {enable = true, extended_mode = true},
    ensure_installed = "maintained",
}

EOF
endif
