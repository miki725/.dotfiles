.SECONDARY:
EMPTY=
SPACE=$(EMPTY) $(EMPTY)
# https://stackoverflow.com/questions/12315834/makefile-how-to-apply-an-equivalent-to-filter-on-multiple-wildcards
containing = $(foreach v,$2,$(if $(findstring $1,$v),$v))
not-containing = $(foreach v,$2,$(if $(findstring $1,$v),,$v))

help:  ## show help
	@grep -E '^[a-zA-Z_\/%\-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		cut -d':' -f2- | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' | \
		sort -t % -k 2.1,2.1

OS=$(shell uname)
SYSTEMD=$(shell which systemctl 2> /dev/null)

include .Makefile.brew .Makefile.pacman
include $(filter-out $(MAKEFILE_LIST),$(wildcard .Makefile.*))

update::  ## update things for install/upgrade
	@

upgrade::  ## upgrade everything
upgrade:: update
upgrade:: upgrade/brew
upgrade:: upgrade/pacman
upgrade:: upgrade/alfred
upgrade:: upgrade/pipx
upgrade:: upgrade/fish
upgrade:: upgrade/npm
upgrade:: upgrade/tmux
upgrade:: upgrade/vim
	@

tidy::  ## tidy things up
	@

all::  ## install everything
all:: minimal
all:: mac
all:: fish
all:: tmux
all:: vim
all:: git
all:: gpg
	$(MAKE) $(OPTIONS) upgrade tidy

ifeq "$(OS)" "Darwin"
mac:  ## adjust various mac settings
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
browserpass: brew/browserpass
	cat $(shell brew --prefix)/opt/browserpass/lib/browserpass/Makefile \
		| sed 's/Chrome/Chrome Beta/g' \
		| PREFIX='$(shell brew --prefix)/opt/browserpass' \
			make -f - hosts-firefox-user hosts-chrome-user hosts-brave-user

gopassbridge: brew/gopass-jsonapi
	gopass-jsonapi configure --browser=chrome
	gopass-jsonapi configure --browser=firefox
tridactyl: .local/share/tridactyl/native_main
else
browserpass:
gopassbridge:
tridactyl:
endif

git:  ## adjust git cofig - conditionally enable gpg signing
git: .gitconfig.user
git: .gitconfig.diff
git: .git-template/hooks/pre-commit

.PHONY: .gitconfig.user
.gitconfig.user: .gnupg/pubring.kbx
	./.bin/gitconfig.user.sh > $@

.PHONY: .gitconfig.diff
.gitconfig.diff:
	./.bin/gitconfig.diff.sh > $@

ifneq "$(shell which pre-commit 2> /dev/null)" ""
.git-template/hooks/pre-commit:
	pre-commit init-templatedir .git-template
else
.git-template/hooks/pre-commit:
	@
endif

gpg:  ## setup gpg config
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
