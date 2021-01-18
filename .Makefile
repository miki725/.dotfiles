help:  ## show help
	@grep -E '^[a-zA-Z_\-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		cut -d':' -f2- | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

OS=$(shell uname)
SYSTEMD=$(shell which systemctl 2> /dev/null)

include .Makefile.brew
include .Makefile.fsh
include .Makefile.node
include .Makefile.pacman
include .Makefile.python
include .Makefile.tmux
include .Makefile.vim

all:  ## install everything
all: brew
all: mac
all: pacman
all: pyenv
all: pipx
all: npm
all: fish
all: tmux
all: git
all: gpg

upgrade:  ## upgrade everything
upgrade: brew-upgrade
upgrade: mac
upgrade: pacman-upgrade
upgrade: pipx-upgrade
upgrade: pyenv
upgrade: npm-upgrade
upgrade: fish-upgrade
upgrade: tmux-upgrade
upgrade: git
upgrade: gpg

ifeq "$(OS)" "Darwin"
mac:  ## adjust various mac settings
mac: .iterm2_shell_integration.fish
mac: .config/bin/imgcat
mac: browserpass
	defaults write -g KeyRepeat -int 1
else
mac:
endif

browserpass:
	PREFIX='/usr/local/opt/browserpass' \
		   make hosts-firefox-user \
		   -f /usr/local/opt/browserpass/lib/browserpass/Makefile
	PREFIX='/usr/local/opt/browserpass' \
		   make hosts-firefox-user \
		   -f /usr/local/opt/browserpass/lib/browserpass/Makefile

.config/bin/imgcat:
	mkdir -p .config/bin
	curl https://iterm2.com/utilities/imgcat > ~/.config/bin/imgcat
	chmod +x ~/.config/bin/imgcat

git:  ## adjust git cofig - conditionally enable gpg signing
git: .gitconfig.user
git: .git-template/hooks/pre-commit

.PHONY: .gitconfig.user
.gitconfig.user:
	@echo > .gitconfig.user
	@-gpg --list-keys --keyid-format LONG miroslav@miki725.com &> /dev/null && \
	echo "[user]" > .gitconfig.user && \
	echo "    signingkey = $$(gpg --list-keys --keyid-format LONG miroslav@miki725.com \
								| grep '\[S\]' \
								| grep -oP '(?<=/)([\w]+)')" >> .gitconfig.user && \
	echo "[commit]" >> .gitconfig.user && \
    echo "    gpgsign = true" >> .gitconfig.user && \
	echo "[gpg]" >> .gitconfig.user && \
	echo "    program = $(shell which gpg)" >> .gitconfig.user

.git-template/hooks/pre-commit:
	pre-commit init-templatedir .git-template

gpg:  ## setup gpg config
gpg: .gnupg/pubring.kbx
gpg: /etc/ssh/sshd_config
gpg: .gitconfig.user

.gnupg/pubring.kbx:
	curl https://keybase.io/miki725/pgp_keys.asc | gpg --import

ifneq "$(SYSTEMD)" ""
.PHONY: /etc/ssh/sshd_config
/etc/ssh/sshd_config:
	grep StreamLocalBindUnlink /etc/ssh/sshd_config &> /dev/null || \
		echo "StreamLocalBindUnlink yes" >> /etc/ssh/sshd_config
	systemctl restart sshd.service
else
/etc/ssh/sshd_config:
endif
