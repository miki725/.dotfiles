#!/usr/bin/env sh

GPG_CMD="gpg --list-keys --keyid-format LONG miroslav@miki725.com"

if ! $GPG_CMD > /dev/null 2>&1; then
    exit 0
fi

cat << EOF
[user]
    signingkey = $(
    $GPG_CMD \
        | grep '\[S\]' \
        | cut -d/ -f2 \
        | awk '{print $1}'
)
[commit]
    gpgsign = true
[tag]
    gpgsign = true
[gpg]
    program = $(which gpg)
EOF
