function sourceenv
    cat $argv | awk '{print "export "$0}' | source
end
