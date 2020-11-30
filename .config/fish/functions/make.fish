function make
    if test "$PWD" = "$HOME"
            and test -f $HOME/.Makefile
        set -l OPTIONS -f $HOME/.Makefile
        command env OPTIONS="$OPTIONS" make $OPTIONS $argv
    else
        command make $argv
    end
end
