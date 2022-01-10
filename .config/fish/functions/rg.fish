function rg -d "same as rg except in $HOME adds --no-ignore since everything is ignored"
    if test (git rev-parse --show-toplevel) = $HOME
        set options --no-ignore
    end
    command rg $options $argv
end
