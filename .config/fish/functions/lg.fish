function lg --wraps lazygit --description 'lazygit in the repo claude is working in within this tmux window, otherwise here'
    # same dir as the C-g tmux popup. see ~/.bin/tmux-review.sh
    if set -q TMUX
        sh ~/.bin/tmux-review.sh lazygit $argv
    else
        lazygit $argv
    end
end
