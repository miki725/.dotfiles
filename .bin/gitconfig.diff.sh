#!/usr/bin/env sh

if ! which delta &> /dev/null; then
    exit 0
fi

cat <<EOF
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true  # use n and N to move between diff sections
    syntax-theme = Monokai Extended Bright
    diff-so-fancy = true
    # diff-highlight = true
    # side-by-side = true
[merge]
    conflictstyle = diff3
[diff]
    colorMoved = default
EOF
