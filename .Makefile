help:  ## show help
	@grep -E '^[a-zA-Z_\-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		cut -d':' -f2- | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

OS=$(shell uname)

include .Makefile.brew
include .Makefile.fsh
include .Makefile.node
include .Makefile.python
include .Makefile.vim

all:  ## install everything
all: mac
all: brew
all: pyenv
all: pipx
all: npm
all: fish

upgrade:  ## upgrade everything
upgrade: brew-upgrade
upgrade: pipx-upgrade
upgrade: pyenv
upgrade: npm-upgrade

ifeq "$(OS)" "Darwin"
mac:  ## adjust various mac settings
	defaults write -g KeyRepeat -int 1
else
mac:
endif
