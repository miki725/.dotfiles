vim:  ## configure vim
vim: .config/nvim/plugin/dotfiles_python_host.vim

upgrade/vim:
	nvim --headless "+Lazy! sync" "+qa"

.config/nvim/plugin/dotfiles_python_host.vim:
	echo > $@
	-neovim2.sh --vim >> $@
	-neovim3.sh --vim >> $@
