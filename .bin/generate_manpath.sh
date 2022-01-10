#!/bin/sh

function generate_manpath_for_root {
	root=$1
	[ -d $root ] || return

	for i in $(
		find -L /usr/local/opt -name '*man*' -type d |
			grep -vE 'man[0-9]' |
			grep -vi command |
			grep -vi resources |
			grep -v '/system/' |
			grep -v '/include' |
			grep -v '/src/' |
			grep -v '/node_modules/' |
			grep -v '/site-packages/'
	); do
		if ls $i | grep -E 'man[0-9]' >/dev/null; then
			echo $i
		fi
	done |
		sort
}

function generate_manpath {
	generate_manpath_for_root /usr/local/opt
	generate_manpath_for_root /opt/homebrew/opt
}

generate_manpath
