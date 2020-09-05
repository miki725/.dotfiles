fish: .iterm2_shell_integration.fish

.iterm2_shell_integration.fish:
	curl -L https://iterm2.com/shell_integration/fish -o ~/.iterm2_shell_integration.fish

fish-clean:
	-rm .path
	-rm .manpath
	-rm .virtualfish.fish
