function dmake --wraps='make -f ~/.Makefile' --wraps='make -f ~/.Makefile -C ~' --description 'run dotfiles make'
    command make -f ~/.Makefile -C ~ --no-print-directory $argv
end
