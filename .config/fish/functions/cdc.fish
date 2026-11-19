function cdc --description 'pushd into the directory claude is working in within this tmux window'
    # picks one when there are several claudes in the window. see ~/.bin/claude-cwd.sh
    set -l dir (sh ~/.bin/claude-cwd.sh $TMUX_PANE)
    or return
    if test -z "$dir"
        echo 'no claude pane in this tmux window' >&2
        return 1
    end
    pushd $dir
end
