.SECONDARY:
EMPTY=
SPACE=$(EMPTY) $(EMPTY)
# https://stackoverflow.com/questions/12315834/makefile-how-to-apply-an-equivalent-to-filter-on-multiple-wildcards
containing = $(foreach v,$2,$(if $(findstring $1,$v),$v))
not-containing = $(foreach v,$2,$(if $(findstring $1,$v),,$v))

# see .bin/make_help.awk for help format
##@ Bundles
##@ Setup
##@ Packages
##@ Maintenance

help:  ## show help
	@awk -v os=$(OS) -f .bin/make_help.awk $(MAKEFILE_LIST)

OS=$(shell uname)
# flags for nested $(MAKE) calls as -f is not passed down via MAKEFLAGS
OPTIONS?=-f $(firstword $(MAKEFILE_LIST))
SYSTEMD=$(shell which systemctl 2> /dev/null)

update::  ## update package manager indexes
## brew update / pacman -Sy - runs automatically before upgrade
	@

upgrade::  ## upgrade everything
## packages (brew, pacman/yay, uv tools, mise, nimble) and
## plugins (fish, tmux, nvim, alfred workflows)
upgrade:: update
	@

include .Makefile.brew
include .Makefile.pacman
include .Makefile.python
include .Makefile.node
include .Makefile.nem
include $(filter-out $(MAKEFILE_LIST),$(wildcard .Makefile.*))

tidy::  ## tidy things up
## removes package caches, unused mise versions and cached .path/.manpath
	@

##@ Bundles
all::  ## install everything
## then runs upgrade and tidy
all:: minimal
all:: mac
all:: fish
all:: tmux
all:: vim
all:: git
all:: gpg
	$(MAKE) $(OPTIONS) upgrade tidy

##@ Setup
ifeq "$(OS)" "Darwin"
mac:  ## adjust various mac settings
## key repeat, notunes -> spotify and browser native hosts
## for browserpass, gopass and tridactyl
mac: browserpass
mac: gopassbridge
mac: mac-keyboard
mac: mac-notunes
mac: tridactyl
else
mac:
endif

mac-keyboard:
	defaults write -g KeyRepeat -int 1

mac-notunes:
	defaults write digital.twisted.noTunes replacement /Applications/Spotify.app

ifeq "$(OS)" "Darwin"
/usr/local/bin:
	sudo mkdir $@

# add gpg to standard PATH so that browserpass can find it
# https://github.com/browserpass/browserpass-native/issues/123
/usr/local/bin/gpg: /usr/local/bin
ifneq "$(shell which gpg 2>/dev/null)" ""
	sudo ln -s $(shell which gpg) $@
endif

browserpass: brew/browserpass /usr/local/bin/gpg
	cat $(BREW_PREFIX)/opt/browserpass/lib/browserpass/Makefile \
		| sed 's/Chrome/Chrome Beta/g' \
		| PREFIX='$(BREW_PREFIX)/opt/browserpass' \
			make -f - \
				hosts-firefox-user \
				hosts-chrome-user \
				hosts-brave-user

.password-store:
	git clone ssh://git@git.miki725.net:3001/miki725/pass.git $@

gopassbridge: brew/gopass-jsonapi .password-store
	gopass-jsonapi configure --browser=chrome
	gopass-jsonapi configure --browser=firefox
tridactyl: .local/share/tridactyl/native_main
else
browserpass:
gopassbridge:
tridactyl:
endif

git:  ## adjust git config
## generates .gitconfig.user (enables gpg signing when key is present)
## .gitconfig.diff and .gitconfig.credential (keychain/cache + oauth
## credential helpers, ssh friendly) as well as pre-commit template hooks
git: .gitconfig.user
git: .gitconfig.diff
git: .gitconfig.credential
git: .git-template/hooks/pre-commit

.gitconfig.user: .bin/gitconfig.user.sh .gnupg/pubring.kbx
	./$< > $@

.gitconfig.diff: brew/git-delta pacman/git-delta
.gitconfig.diff: .bin/gitconfig.diff.sh
	./$< > $@

.gitconfig.credential: brew/git-credential-oauth pacman/git-credential-oauth
.gitconfig.credential: .bin/gitconfig.credential.sh
	./$< > $@

ifneq "$(shell which pre-commit 2> /dev/null)" ""
.git-template/hooks/pre-commit:
	pre-commit init-templatedir .git-template
else
.git-template/hooks/pre-commit:
	@
endif

gpg:  ## setup gpg config
## imports public key from github and configures gpg-agent
## with ssh support (and pinentry-mac on mac)
gpg: .gnupg/pubring.kbx
gpg: .gnupg/gpg-agent.conf
gpg: .gnupg/sshcontrol
gpg: /etc/ssh/sshd_config
gpg: .gitconfig.user
	chmod 0700 .gnupg

.gnupg/gpg-agent.conf::
	echo "enable-ssh-support" > $@

ifneq "$(shell which pinentry-mac 2> /dev/null)" ""
.gnupg/gpg-agent.conf::
	echo "pinentry-program $(shell which pinentry-mac)" >> $@
endif

.gnupg/pubring.kbx:
	curl -sfSL https://github.com/miki725.gpg | gpg --import
	chmod 0600 $@

.gnupg/sshcontrol: .gnupg/pubring.kbx
	./.bin/gpg.sshcontrol.sh > $@

ifneq "$(SYSTEMD)" ""
.PHONY: /etc/ssh/sshd_config
/etc/ssh/sshd_config:
	sudo grep StreamLocalBindUnlink $@ &> /dev/null || \
		echo "StreamLocalBindUnlink yes" >> $@
	sudo sed 's/^#X11Forwarding.*/X11Forwarding yes/' -i $@
	sudo sed 's/^#X11UseLocalhost.*/X11UseLocalhost yes/' -i $@
	sudo systemctl restart sshd.service
else
/etc/ssh/sshd_config:
endif

ssh:  ## setup ssh to allow ssh from gpg key
## authorizes github public keys in .ssh/authorized_keys
ssh: gpg
ssh: .ssh/authorized_keys

.ssh:
	mkdir $@
	chmod 0700 $@

.ssh/authorized_keys: .ssh
	curl -sfSL https://github.com/miki725.keys > $@
	chmod 0600 $@

.local/share/tridactyl/native_main:
	curl -fsSl https://raw.githubusercontent.com/tridactyl/native_messenger/master/installers/install.sh | sh -s -- 1.24.2

ifeq "$(shell grep Defaults:root /etc/sudoers 2> /dev/null)" ""
.PHONY: /etc/sudoers
endif
/etc/sudoers:
	grep Defaults:root $@ || echo Defaults:root runcwd=* >> $@
	grep Defaults:%wheel $@ || echo Defaults:%wheel runcwd=* >> $@
