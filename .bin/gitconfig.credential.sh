#!/usr/bin/env sh

echo "[credential]"

# storage helper
if [ "$(uname)" = "Darwin" ]; then
    echo "    helper = osxkeychain"
else
    echo "    helper = cache --timeout 21600  # six hours"
fi

# oauth needs to come after the storage helper
if which git-credential-oauth > /dev/null 2>&1; then
    # over ssh there is no local browser so use device flow
    # which prints a code to enter on another device
    if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        echo "    helper = oauth -device"
    else
        echo "    helper = oauth"
    fi
fi
