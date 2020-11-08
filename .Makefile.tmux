TMUX_TPM=$(HOME)/.tmux/plugins/tpm

$(TMUX_TPM):
	mkdir -p $(TMUX_TPM)
	git clone https://github.com/tmux-plugins/tpm $(TMUX_TPM)
	$(TMUX_TPM)/bin/install_plugins

tmux:  ## configure tmux package manager
tmux: $(TMUX_TPM)

tmux-upgrade:  ## upgrade tmux packages
tmux-upgrade: $(TMUX_TPM)
	$(TMUX_TPM)/bin/install_plugins
	$(TMUX_TPM)/bin/update_plugins all
