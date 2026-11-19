function cdc --description 'pushd into the directory claude is working in within this tmux window'
    # several claudes in one window so pick one in a tmux popup. see ~/.bin/claude-cwd.sh
    set -l dir (sh ~/.bin/claude-cwd.sh $TMUX_PANE --tmux)
    or return
    if test -z "$dir"
        echo 'no claude pane in this tmux window' >&2
        return 1
    end
    pushd $dir
end
