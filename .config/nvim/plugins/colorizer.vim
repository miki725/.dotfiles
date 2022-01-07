if PlugLoaded('nvim-colorizer.lua')
lua << EOF
require'colorizer'.setup()
EOF
endif
