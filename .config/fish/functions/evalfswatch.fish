function evalfswatch

    argparse 'w-watch=' 'r/reset' -- $argv
    or return

    if test -z "$_flag_watch"
        set _flag_watch "."
    end

    while true
        if test -n "$_flag_r"
            reset
        end
        fswatch $_flag_watch | $argv
        sleep 1
    end
end
