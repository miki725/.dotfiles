function git_fzf --description "cd into git worktree via fzf selection"
    pushd (git worktree list --porcelain | grep worktree | awk '{print $2}' | fzf)
end
