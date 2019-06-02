for f in split(glob('~/.vim/plugins/plugin_*_config.vim'), '\n')
    exe 'source' f
endfor
