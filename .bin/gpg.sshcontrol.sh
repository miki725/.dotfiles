#!/usr/bin/env sh

set -e

gpg --list-keys --keyid-format LONG --with-keygrip miroslav@miki725.com \
    | grep '\[A\]' -A1 \
    | tail -n1 \
    | awk '{print $3}'
