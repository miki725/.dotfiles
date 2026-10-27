upgrade:: upgrade/vim

upgrade/vim:  ## sync nvim lazy plugins
upgrade/vim:
	nvim --headless "+Lazy! sync" "+qa"
