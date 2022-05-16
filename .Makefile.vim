vim:  ## configure vim
vim: .config/nvim/dotfiles/python_host.vim

upgrade::
	vim -C PackerSync

.config/nvim/dotfiles/python_host.vim:
	echo > $@
	-neovim2.sh --vim >> $@
	-neovim3.sh --vim >> $@
