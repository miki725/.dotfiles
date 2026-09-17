#!/bin/sh
exec /bin/sh "$HOME/.bin/exec_first_found.sh" \
    "fish --login" \
    "bash --login" \
    "zsh --login"
