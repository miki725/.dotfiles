function evalfswatch
    argparse -i 'w/watch=' r/reset -- $argv
    or return

    if test -z "$_flag_watch"
        set _flag_watch "."
    end

    while true
        if test -n "$_flag_r"
            reset
        end
        # eval allows to work with expand wildcards
        # which fswatch does not expand itself
        eval "fswatch $_flag_watch | fish -c \"$argv\""
        sleep 1
    end
end
