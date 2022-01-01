TMUX_TPM=$(HOME)/.tmux/plugins/tpm

ifneq "$(wildcard $(TMUX_TPM))" ""
upgrade::
upgrade:: $(TMUX_TPM)
	cd $(TMUX_TPM) && git pull
	$(TMUX_TPM)/bin/install_plugins
	$(TMUX_TPM)/bin/update_plugins all
endif

tmux:  ## configure tmux package manager
tmux: $(TMUX_TPM)

$(TMUX_TPM):
	mkdir -p $@
	git clone https://github.com/tmux-plugins/tpm $(TMUX_TPM)
	$(TMUX_TPM)/bin/install_plugins
