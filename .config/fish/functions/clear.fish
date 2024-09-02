function clear
    command clear
    if type -q tmux
        tmux clear-history
    end
end
