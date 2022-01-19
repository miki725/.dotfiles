#!/bin/sh

source $HOME/.bin/ensure_path.sh

for arg; do
    shift
    which $(echo "$arg" | awk '{print $1}') > /dev/null 2>&1 && exec $arg
    set -- "$@" "@arg"
done

exec sh
