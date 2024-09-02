function reset
    command reset
    if type -q tmux
        tmux clear-history
    end
end
