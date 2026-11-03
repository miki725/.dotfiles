#!/bin/sh
# gpg wrapper (git gpg.program) which tells pinentry who is asking for the pin
# via PINENTRY_USER_DATA so that with multiple sessions (claude, tmux panes)
# it is obvious which one triggered the yubikey prompt. see pinentry-context.sh
# gpg truncates the value at a newline so lines are separated with literal \n
# within tmux the first line is "@tmux <pane> <socket>" so that pinentry can flag
# the window while the prompt is up

if [ -z "$PINENTRY_USER_DATA" ]; then
    context=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ -z "$context" ]; then
        context=$(pwd)
    fi
    context=$(printf '%s' "$context" | sed "s|^$HOME|~|")

    if [ -n "$TMUX_PANE" ]; then
        tmux=$(tmux display -p -t "$TMUX_PANE" '#{window_index}:#{window_name}' 2> /dev/null)
        # title is the most specific but tmux defaults it to the hostname which is
        # meaningless so then leave it out. claude sets it to its session title
        # which the claude line below already shows so leave it out there too
        title=$(tmux display -p -t "$TMUX_PANE" '#{pane_title}' 2> /dev/null)
        if [ -z "$CLAUDECODE" ] && [ -n "$title" ] && [ "$title" != "$(tmux display -p '#{host}')" ]; then
            tmux="$tmux | $title"
        fi
        # session name only helps to tell sessions apart when there are multiple
        sessions=$(tmux display -p '#{server_sessions}' 2> /dev/null)
        if [ "${sessions:-0}" -gt 1 ]; then
            tmux="$(tmux display -p -t "$TMUX_PANE" '#{session_name}') $tmux"
        fi
        if [ -n "$tmux" ]; then
            context="$context\\ntmux $tmux"
        fi
        context="@tmux $TMUX_PANE ${TMUX%%,*}\\n$context"
    fi

    if [ -n "$CLAUDECODE" ]; then
        # session title is in the session transcript. prefer the title set
        # via /rename over the generated one and fallback to session id
        claude=$CLAUDE_CODE_SESSION_ID
        transcript=$(ls "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"/projects/*/"$CLAUDE_CODE_SESSION_ID".jsonl 2> /dev/null | head -1)
        if [ -n "$CLAUDE_CODE_SESSION_ID" ] && [ -n "$transcript" ]; then
            for key in customTitle aiTitle; do
                title=$(grep -o "\"$key\":\"[^\"]*\"" "$transcript" | tail -1 | sed "s/^\"$key\":\"//; s/\"$//")
                if [ -n "$title" ]; then
                    claude=$title
                    break
                fi
            done
        fi
        context="$context\\nclaude ${claude:-session}"
    fi

    PINENTRY_USER_DATA=$context
    export PINENTRY_USER_DATA
fi

exec gpg "$@"
