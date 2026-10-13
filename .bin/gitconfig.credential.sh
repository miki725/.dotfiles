#!/bin/sh

# without args generates .gitconfig.credential
# with args (get/store/erase) acts as git credential helper over ssh.
# over ssh there is no local browser so it first tries device flow
# (github, gitlab) which prints a code to enter on another device.
# hosts without device flow (gitea) fall back to browser flow where
# the redirect back to 127.0.0.1 fails on the other device so after logging in
# paste the url the browser failed to load and it is delivered to the helper
# from this machine.

if [ $# -eq 0 ]; then
    # storage helper
    if [ "$(uname)" = "Darwin" ]; then
        storage="osxkeychain"
    else
        storage="cache --timeout 21600  # six hours"
    fi

    cat << EOF
[credential]
    helper = $storage
EOF

    if ! command -v git-credential-oauth > /dev/null; then
        exit 0
    fi

    # oauth needs to come after the storage helper
    if [ -z "$SSH_CONNECTION$SSH_CLIENT$SSH_TTY" ]; then
        echo "    helper = oauth"
    else
        echo "    helper = !\"$(cd "$(dirname "$0")" && pwd)/$(basename "$0")\""
    fi
    exit 0
fi

if [ "$1" != "get" ] || ! (: < /dev/tty) 2> /dev/null; then
    exec git-credential-oauth "$@"
fi

tmp=$(mktemp -d)
trap 'kill $pid 2> /dev/null; rm -rf "$tmp"' EXIT

# background jobs get /dev/null stdin so save git's input
cat > "$tmp/in"

# run helper in background until it finishes or asks to visit a url
oauth() {
    shown=0
    BROWSER=true git-credential-oauth "$@" < "$tmp/in" > "$tmp/out" 2> "$tmp/err" &
    pid=$!
    while kill -0 $pid 2> /dev/null && ! grep -Eq 'https?://' "$tmp/err"; do
        sleep 0.1
    done
    if kill -0 $pid 2> /dev/null; then
        cat "$tmp/err" > /dev/tty
        shown=$(wc -c < "$tmp/err")
    fi
}

finish() {
    wait $pid
    status=$?
    tail -c +$((shown + 1)) "$tmp/err" >&2
    cat "$tmp/out"
    exit $status
}

oauth -device "$@"
if kill -0 $pid 2> /dev/null || ! grep -q DeviceAuthURL "$tmp/err"; then
    finish
fi

oauth "$@"
while kill -0 $pid 2> /dev/null; do
    printf 'Paste url browser was redirected to (http://127.0.0.1:...): ' > /dev/tty
    read -r url < /dev/tty
    curl -fsS -o /dev/null "$url" > /dev/tty 2>&1 && sleep 1
done
finish
