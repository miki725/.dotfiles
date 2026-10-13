#!/usr/bin/env sh

if [ "$(uname)" != "Darwin" ]; then
    exit 0
fi

cat << EOF
[credential]
    helper = osxkeychain
EOF

# oauth needs to come after the storage helper
if which git-credential-oauth > /dev/null 2>&1; then
    echo "    helper = oauth"
fi
