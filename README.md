# .dotfiles

My homegrown system for managing dotfiles

## Init

Everything is directly in git. Just make `$HOME` a git folder:

```sh
git init
git remote add origin https://github.com/miki725/.dotfiles.git
git fetch
git reset --hard origin/master
```

## Help

Most targets can be seen in help:

```sh
make -f .Makefile minimal
```

## Deps

Deps are managed via makefile helpers for package managers:

```sh
make -f .Makefile brew/fzf
make -f .Makefile cask/firefox
make -f .Makefile npm/prettier
make -f .Makefile pacman/fzf
make -f .Makefile pipx/awscli
make -f .Makefile pyenv/3.10
make -f .Makefile yay/zoxide-bin
```

There are some install bundles like:

```sh
make -f .Makefile minimal
```

## Other Files

Makefile manages some other files like if `gpg` is setup it automatically
sets git to use it for git signing:

```sh
make -f .Makefile git
```
