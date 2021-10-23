#!/bin/sh

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

for arg do
    shift
    which $(echo "$arg" | awk '{print $1}') > /dev/null 2>&1 && exec $arg
    set -- "$@" "@arg"
done

exec sh
