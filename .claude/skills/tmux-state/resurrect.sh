#!/bin/sh
# tmux-resurrect hooks to resume claude conversations in the same panes
# save: dump @claude_session pane options (set by hooks/state.sh) next to the resurrect save
# restore: run claude --resume in each restored pane which is still sitting at a shell prompt
# session:window.pane targets are stable across resurrect unlike pane ids
file=${XDG_STATE_HOME:-$HOME/.local/state}/tmux/claude-sessions

case "$1" in
    layout)
        # $2 is the resurrect save file. drop gopass commands and titles from panes
        # so secret names or decrypted temp paths are neither saved nor rerun on restore
        awk -F '\t' -v OFS='\t' '$1 == "pane" { for (i = 7; i <= NF; i++) if ($i ~ /gopass/) $i = ($i ~ /^:/) ? ":" : "" } 1' \
            "$2" > "$2.tmp" && mv "$2.tmp" "$2"
        ;;
    save)
        mkdir -p "$(dirname "$file")"
        # session id first as session names can have spaces. panes without claude start with a space
        tmux list-panes -a -F '#{@claude_session} #{session_name}:#{window_index}.#{pane_index}' \
            | grep -v '^ ' > "$file.tmp"
        mv "$file.tmp" "$file"
        ;;
    restore)
        [ -f "$file" ] || exit 0
        while read -r session target; do
            case "$(tmux display -p -t "$target" '#{pane_current_command}' 2> /dev/null)" in
                zsh | bash | sh | fish)
                    tmux send-keys -t "$target" "claude --resume $session" Enter
                    ;;
            esac
        done < "$file"
        ;;
esac
