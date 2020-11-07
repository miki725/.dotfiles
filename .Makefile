help:  ## show help
	@grep -E '^[a-zA-Z_\-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		cut -d':' -f2- | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

OS=$(shell uname)

include .Makefile.brew
include .Makefile.fsh
include .Makefile.node
include .Makefile.pacman
include .Makefile.python
include .Makefile.tmux
include .Makefile.vim

all:  ## install everything
all: mac
all: brew
all: pacman
all: pyenv
all: pipx
all: npm
all: fish
all: tmux

upgrade:  ## upgrade everything
upgrade: brew-upgrade
upgrade: pacman-upgrade
upgrade: pipx-upgrade
upgrade: pyenv
upgrade: npm-upgrade
upgrade: fish-upgrade
upgrade: tmux-upgrade

ifeq "$(OS)" "Darwin"
mac:  ## adjust various mac settings
mac: .iterm2_shell_integration.fish
mac: .config/bin/imgcat
	defaults write -g KeyRepeat -int 1
else
mac:
endif

.config/bin/imgcat:
	curl https://iterm2.com/utilities/imgcat > ~/.config/bin/imgcat
	chmod ~/.config/bin/imgcat
