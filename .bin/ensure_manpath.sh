#!/bin/sh

path_file=$HOME/.manpath

if ! [ -f $path_file ]; then
    sh $HOME/.bin/generate_manpath.sh > $path_file
fi

export MANPATH=$(paste -sd: $path_file)
