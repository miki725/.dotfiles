#!/bin/sh

function filter_valid_paths {
    while read line; do
        [ -n "$line" ] && [ -d "$line" ] && echo $line
    done
}

echo "\
$HOME/.bin
$HOME/.local/bin
$HOME/.cargo/bin
$HOME/.yarn/bin
$HOME/.n/bin
$HOME/go/bin
$HOME/.go/bin
$HOME/.config/yarn/global/node_modules/.bin
" | filter_valid_paths

if [ -d $HOME/Library/Python ]; then
    find $HOME/Library/Python/ -name bin -type d | sort -r
fi

if [ -d $HOME/.pyenv/versions ]; then
    find $HOME/.pyenv/versions -maxdepth 2 -name bin -type d | sort -r --version-sort
fi

echo "\
/usr/local/bin
/usr/local/sbin
/opt/homebrew/bin
" | filter_valid_paths

for i in $(echo -n "
/usr/local/opt
/opt/homebrew/opt
"); do
    if [ -d $i ]; then
        find -L $i -type d -name '*bin' \
            | grep -v '/node_modules/' \
            | grep -v '/gems/' \
            | sort
    fi
done

for i in $(echo -n "
/usr/local/Cellar
/opt/homebrew/Cellar
"); do
    if [ -d $i ]; then
        find -L $i -maxdepth 3 -type d -name '*bin' \
            | grep -v '/node_modules/' \
            | grep -v '/gems/' \
            | sort
    fi
done

echo "\
/Library/TeX/texbin
/opt/X11/bin
/usr/bin
/bin
/usr/sbin
/sbin
" | filter_valid_paths
