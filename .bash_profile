# ssh autocomplete
function _ssh_completion() {
  perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config
}
complete -W "$(_ssh_completion)" ssh

PATH=$HOME/bin:$HOME/.cargo/bin:/usr/local/bin:$PATH
export PATH

source $HOME/.bash_prompt.sh
export LSCOLORS=dxfxcxdxbxegedabagacad

alias ls="ls -G"
alias ll="ls -lh"
alias la="ls -la"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
