# .dotfiles

My homegrown system for managing dotfiles

## Init

Everything is directly in git. Just make `$HOME` a git folder:

```sh
git init
git remote add origin https://github.com/miki725/.dotfiles.git
git fetch
git reset --hard origin/main
```

## Help

Most targets can be seen in help:

```sh
make -f .Makefile help
```

## Deps

Deps are managed via makefile helpers for package managers:

```sh
make -f .Makefile brew/fzf
make -f .Makefile cask/firefox
make -f .Makefile pacman/fzf
make -f .Makefile yay/zoxide-bin
make -f .Makefile uv/httpie
make -f .Makefile uv/python/3.14
make -f .Makefile mise/npm/prettier
make -f .Makefile mise/node/24
make -f .Makefile nimble/inim
```

There are some install bundles like:

```sh
make -f .Makefile minimal
make -f .Makefile dev
make -f .Makefile all
```

Everything installed can be upgraded and cleaned up with:

```sh
make -f .Makefile upgrade tidy
```

## Other Files

Makefile manages some other files like if `gpg` is setup it automatically
sets git to use it for git signing:

```sh
make -f .Makefile git
```
