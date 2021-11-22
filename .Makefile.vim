vim:  ## configure vim
vim: .vim/dotfiles/python_host.vim

.vim/dotfiles/python_host.vim:
	echo > $@
	-neovim2.sh --vim >> $@
	-neovim3.sh --vim >> $@
