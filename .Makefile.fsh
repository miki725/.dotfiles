fish:  ## install fish deps
fish: fish-clean
fish: fish-virtualfish

fish-virtualfish:
	-fish --login -c 'vf uninstall'
	fish --login -c 'which vf; and vf install auto_activation compat_aliases projects'

.iterm2_shell_integration.fish:
	curl -L https://iterm2.com/shell_integration/fish -o ~/.iterm2_shell_integration.fish

fish-clean:
	-rm .path
	-rm .manpath

fish-upgrade:  ## upgrade fish tools and regeneate computed components
fish-upgrade: fish-clean
fish-upgrade: fish-virtualfish
	fish -c 'fisher update'
	fish -c 'fish_update_completions'
