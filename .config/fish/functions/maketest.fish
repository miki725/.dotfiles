function maketest
    argparse \
        --ignore-unknown \
        't/target=&' \
        -- $argv
    if test -z "$_flag_target"
        set _flag_target tests
    end
    reset
    make $_flag_target args="$argv"
end
