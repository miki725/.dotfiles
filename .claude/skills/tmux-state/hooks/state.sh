#!/bin/sh
# set @claude on the tmux window: running, waiting, background, idle or clear
# waiting is only for when input is definitely needed. otherwise when turn ends ring the bell
# as claude might be just done which clears on visiting the window unlike @claude
[ -n "$TMUX" ] || exit 0

case "$1" in
    tool)
        input=$(cat)
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
        if jq -e '((.background_tasks // []) + (.session_crons // []) | length) > 0' > /dev/null 2>&1; then
            state=background
        else
            state=idle
            printf '\a' > "$(tmux display -p -t "$TMUX_PANE" '#{pane_tty}')"
        fi
        ;;
    *)
        state=$1
        ;;
esac

if [ "$state" = clear ]; then
    tmux set -wu -t "$TMUX_PANE" @claude
else
    tmux set -w -t "$TMUX_PANE" @claude "$state"
fi
