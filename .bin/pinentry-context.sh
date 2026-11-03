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

# assuan is line based so rewrite SETDESC lines from gpg-agent on the fly
# (data is percent-escaped as per assuan and literal \n become newlines)
# and pass everything else through as is
# context is also escaped for the sed replacement below (\ & and | delimiter)
context=$(
    printf '%s' "$PINENTRY_USER_DATA" \
        | tr -d '\r' \
        | sed -e 's/%/%25/g' -e 's/\\n/%0A/g' -e 's/[\\&|]/\\&/g'
)
# -u to not buffer as pinentry needs each command right away
sed -u "s|^SETDESC .*|&%0A%0A$context|" | exec "$real" "$@"
