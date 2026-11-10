#!/bin/sh
# set @claude on the tmux window: running, waiting, background, idle or clear
# waiting is only for when input is definitely needed and also rings the bell to get attention.
# otherwise when turn ends only ring the bell as claude might be just done
# which clears on visiting the window unlike @claude
# also keep the dir claude works in (its last worktree) in the @claude_cwd pane option so other panes can follow it
[ -n "$TMUX" ] || exit 0

input=$(cat)

bell() {
    printf '\a' > "$(tmux display -p -t "$TMUX_PANE" '#{pane_tty}')"
}

# claude mostly works in worktrees or other repos via absolute paths while its cwd stays at the session root
# so follow the last other repo (worktrees are their own) mentioned in tool input
# and ignore cwd when its the session root as claude often resets back to it
track_cwd() {
    cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2> /dev/null)
    [ -n "$cwd" ] || return
    root=$(git -C "$cwd" rev-parse --show-toplevel 2> /dev/null || printf '%s' "$cwd")
    repo=$(
        printf '%s' "$input" \
            | jq -r '.tool_input // {} | .file_path, .notebook_path, .path, .command | strings' 2> /dev/null \
            | grep -oE "[^[:space:]\"'=:;&|<>()]*/[^[:space:]\"'=:;&|<>()]*" \
            | while read -r path; do
                case "$path" in
                    (/*) ;;
                    (\~/*) path="$HOME/${path#\~/}" ;;
                    (*) path="$cwd/$path" ;;
                esac
                # closest existing dir as the path can be a file or not created yet
                while [ -n "$path" ] && [ ! -d "$path" ]; do
                    path=${path%/*}
                done
                [ -n "$path" ] && printf '%s\n' "$path"
            done \
            | awk '!seen[$0]++' \
            | while read -r dir; do
                git -C "$dir" rev-parse --show-toplevel 2> /dev/null
            done \
            | while read -r top; do
                # dotfiles repo in $HOME contains everything so only stray reads would land there
                [ "$top" != "$root" ] && [ "$top" != "$HOME" ] && printf '%s\n' "$top"
            done \
            | tail -n 1
    )
    if [ -n "$repo" ]; then
        dir=$repo
    # cwd only says something when claude moved away from the session root
    elif [ "$cwd" != "$CLAUDE_PROJECT_DIR" ] || [ -z "$(tmux display -p -t "$TMUX_PANE" '#{@claude_cwd}')" ]; then
        dir=$cwd
    else
        return
    fi
    tmux set -p -t "$TMUX_PANE" @claude_cwd "$dir"
}

case "$1" in
    tool)
        # these tools wait for an answer
        if printf '%s' "$input" | jq -e '.hook_event_name == "PreToolUse" and (.tool_name == "AskUserQuestion" or .tool_name == "ExitPlanMode")' > /dev/null 2>&1; then
            state=waiting
        # tool calls from subagents dont mean main claude is busy as it can be waiting on them in background
        elif printf '%s' "$input" | jq -e '.agent_id' > /dev/null 2>&1; then
            exit 0
        else
            state=running
        fi
        ;;
    stop)
        # turn ended but background work can still wake claude up
        # except artifact watches which are armed on every publish and never finish
        if printf '%s' "$input" | jq -e '((.background_tasks // []) | map(select((.description // "") | startswith("live updates for artifact") | not))) + (.session_crons // []) | length > 0' > /dev/null 2>&1; then
            state=background
        else
            state=idle
            bell
        fi
        ;;
    start)
        # remember conversation on the pane so tmux-resurrect can resume it. see resurrect.sh
        session=$(printf '%s' "$input" | jq -r '.session_id // empty' 2> /dev/null)
        [ -n "$session" ] && tmux set -p -t "$TMUX_PANE" @claude_session "$session"
        state=idle
        ;;
    *)
        state=$1
        ;;
esac

[ "$state" = waiting ] && bell

if [ "$state" = clear ]; then
    tmux set -wu -t "$TMUX_PANE" @claude
    tmux set -pu -t "$TMUX_PANE" @claude_session
    tmux set -pu -t "$TMUX_PANE" @claude_cwd
else
    tmux set -w -t "$TMUX_PANE" @claude "$state"
    track_cwd
fi
