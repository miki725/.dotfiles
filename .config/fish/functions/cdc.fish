function cdc --description 'pushd into the directory claude is working in within this tmux window'
    # @claude_cwd is set on claude panes by the tmux-state claude plugin hooks
    set -l dirs (tmux list-panes -t $TMUX_PANE -F '#{@claude_cwd}' 2>/dev/null | string match -v '' | sort -u)
    if test (count $dirs) -eq 0
        echo 'no claude pane in this tmux window' >&2
        return 1
    end
    set -l dir $dirs[1]
    # several claudes in one window so pick one in a tmux popup
    if test (count $dirs) -gt 1
        set dir (printf '%s\n' $dirs | fzf --tmux)
        or return
    end
    pushd $dir
end
