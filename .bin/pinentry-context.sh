#!/bin/sh
# pinentry wrapper (gpg-agent pinentry-program) which appends PINENTRY_USER_DATA
# to the prompt description. see gpg-context.sh

# gpg-agent can be started with minimal PATH
. "$HOME/.bin/ensure_path.sh"

real=$PINENTRY_REAL
if [ -z "$real" ]; then
    for name in pinentry-mac pinentry pinentry-gnome3 pinentry-qt pinentry-gtk-2 pinentry-curses pinentry-tty; do
        real=$(command -v "$name")
        if [ -n "$real" ]; then
            break
        fi
    done
fi
if [ -z "$real" ]; then
    echo "pinentry-context: no pinentry found in PATH" >&2
    exit 1
fi

if [ -z "$PINENTRY_USER_DATA" ]; then
    exec "$real" "$@"
fi

# while the prompt is up flag the tmux window which asks for the pin (shown with a
# cyan lock icon, see .tmux.conf) and ring its bell so it is easy to find in window lists
case "$PINENTRY_USER_DATA" in
    "@tmux "*)
        read -r _ pane socket << EOF
$(printf '%s' "$PINENTRY_USER_DATA" | sed 's/\\n.*//')
EOF
        PINENTRY_USER_DATA=$(printf '%s' "$PINENTRY_USER_DATA" | sed 's/^@tmux [^\\]*\\n//')
        tty=$(tmux -S "$socket" display -p -t "$pane" '#{pane_tty}' 2> /dev/null)
        if [ -n "$tty" ]; then
            tmux -S "$socket" set -w -t "$pane" @pinentry 1
            printf '\a' > "$tty"
            trap 'tmux -S "$socket" set -wu -t "$pane" @pinentry 2> /dev/null' EXIT
            trap 'exit 1' HUP INT TERM
        fi
        ;;
esac

# assuan is line based so rewrite SETDESC lines from gpg-agent on the fly
# (data is percent-escaped as per assuan and literal \n become newlines)
# and pass everything else through as is
# assuan lines are limited to ~1000 bytes and pinentry fails on longer ones
# so cut the context to fit without splitting a %XX escape or utf-8 character
PINENTRY_CONTEXT=$(
    printf '%s' "$PINENTRY_USER_DATA" \
        | tr -d '\r' \
        | sed -e 's/%/%25/g' -e 's/\\n/%0A/g'
)
export PINENTRY_CONTEXT
# stdin is saved on fd 4 as background commands otherwise get /dev/null
exec 4<&0
# awk flushes each line as pinentry needs each command right away
LC_ALL=C awk -v max=990 '
    /^SETDESC / {
        $0 = $0 "%0A%0A" ENVIRON["PINENTRY_CONTEXT"]
        if (length($0) > max) {
            $0 = substr($0, 1, max - 6)
            sub(/%.?$/, "")
            sub(/[\300-\377][\200-\277]*$/, "")
            $0 = $0 "%0A..."
        }
    }
    { print; fflush() }
' <&4 4<&- | "$real" "$@" 4<&- &
# no exec so that the tmux flag above is cleared once pinentry is done but then
# close the copies of gpg-agent pipes here. otherwise when pinentry fails gpg-agent
# never sees its output close and hangs along with every pinentry request after it
exec 0<&- 1>&- 4<&-
wait $!
