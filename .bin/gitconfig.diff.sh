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
    # diff-so-fancy colors whole lines flat red/green so restore syntax highlighting
    zero-style = syntax
    minus-style = syntax "#3f0001"
    minus-non-emph-style = syntax "#3f0001"
    minus-emph-style = syntax "#901011"
    plus-style = syntax "#002800"
    plus-non-emph-style = syntax "#002800"
    plus-emph-style = syntax "#006000"
    # diff-highlight = true
    # side-by-side = true
[merge]
    conflictstyle = diff3
[diff]
    colorMoved = default
EOF
