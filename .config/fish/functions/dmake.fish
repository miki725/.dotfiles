function dmake --wraps='make -f ~/.Makefile' --wraps='make -f ~/.Makefile -C ~' --description 'run dotfiles make'
    make -f ~/.Makefile -C ~ $argv
end
