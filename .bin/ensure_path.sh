#!/bin/sh

hook=$HOME/.path-hook
path_file=$HOME/.path

if ! [ -z "${PATH##*$hook*}" ]; then

	if ! [ -f $path_file ]; then
		sh $HOME/.bin/generate_path.sh >$path_file
	fi

	PATH=$hook:$(paste -sd: $path_file)

	# sometimes within subshell when VIRTUAL_ENV is already set
	# above PATH adjustements will put VIRTUAL_ENV not on top of PATH
	# hence ignoring most of PATH order
	if [ -n "$VIRTUAL_ENV" ]; then
		PATH=$VIRTUAL_ENV/bin:$PATH
	fi

	export PATH
fi
