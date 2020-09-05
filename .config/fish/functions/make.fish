function make
    if test "$PWD" = "$HOME"
        command make -f .Makefile $argv
    else
        command make $argv
    end
end
