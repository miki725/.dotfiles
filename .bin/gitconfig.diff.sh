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
[merge]
    conflictstyle = diff3
[diff]
    colorMoved = default
EOF
