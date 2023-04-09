tidy::
	-rm .path
	-rm .manpath

upgrade::
upgrade::
upgrade:: fish-virtualfish
	fish -c 'fisher update'
	fish -c 'fish_update_completions'

fish:  ## install fish deps
fish: fish-virtualfish

ifneq "$(shell which vf 2> /dev/null)" ""
fish-virtualfish:
	-fish --login -c 'vf uninstall'
	fish --login -c 'which vf; and vf install; and vf addplugins auto_activation compat_aliases projects'
else
fish-virtualfish:
	@
endif
