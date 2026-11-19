#!/bin/sh
# run a review command (lazygit, nvim diffs) in a tmux popup (see .tmux.conf) in the dir claude
# works in as its own cwd stays at the session root, otherwise in the pane's own cwd.
# see claude-cwd.sh for which claude
# a popup has no TMUX_PANE so take the pane it opened over which is the client's active pane.
# gpg-context.sh needs it to show and flag the window when signing asks for the pin
TMUX_PANE=$(tmux display -p '#{pane_id}')
export TMUX_PANE

dir=$(sh "$HOME/.bin/claude-cwd.sh" "$TMUX_PANE") || exit
if [ -z "$dir" ]; then
    dir=$(tmux display -p -t "$TMUX_PANE" '#{pane_current_path}')
fi
cd "$dir" || exit
exec "$@"
