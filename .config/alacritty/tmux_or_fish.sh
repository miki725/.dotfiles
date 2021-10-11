#!/bin/bash

PATH=$PATH
if [ -e $HOME/.path ]
then
    for i in $(nl $HOME/.path  | sort -nr | cut -f 2-);
    do
        if [ -e $i ]
        then
            PATH=$i:$PATH
        fi
    done
fi
export PATH

which tmux 2> /dev/null && exec tmux || exec fish --login
