#!/bin/sh
# print the dir claude works in for a tmux pane (default: the current one) from @claude_cwd
# which the tmux-state claude plugin hooks set on claude panes.
# a claude pane uses its own while other panes use the claudes in their window and pick one
# with fzf when there are several (args after the pane go to fzf).
# prints nothing when there is none and fails when the pick is cancelled.
# used by the cdc fish function and tmux-review.sh
pane=${1:-$TMUX_PANE}
[ $# -gt 0 ] && shift

# dirs of removed worktrees can linger until claude's next hook
existing() {
    while read -r dir; do
        [ -n "$dir" ] && [ -d "$dir" ] && printf '%s\n' "$dir"
    done
}

dirs=$(tmux display -p -t "$pane" '#{@claude_cwd}' | existing)
if [ -z "$dirs" ]; then
    dirs=$(tmux list-panes -t "$pane" -F '#{@claude_cwd}' | existing | sort -u)
fi
case $(printf '%s' "$dirs" | grep -c '') in
    0) ;;
    1) printf '%s\n' "$dirs" ;;
    *) printf '%s\n' "$dirs" | fzf "$@" ;;
esac
