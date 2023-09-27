vim:  ## configure vim
vim: .config/nvim/plugin/dotfiles_python_host.vim

upgrade::
	nvim -c PackerSync

.config/nvim/plugin/dotfiles_python_host.vim:
	echo > $@
	-neovim2.sh --vim >> $@
	-neovim3.sh --vim >> $@
