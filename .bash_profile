PATH=$PATH
if [ -e $HOME/.path ]
then
    for i in $(nl $HOME/.path  | sort -nr | cut -f 2-);
    do
        if [ -e $i ]
        then
            PATH=$i:$PATH
        fi
    done
fi
export PATH

# ssh autocomplete
function _ssh_completion() {
  perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config
}
complete -W "$(_ssh_completion)" ssh 2> /dev/null || true

source $HOME/.bash_prompt.sh
export LSCOLORS=dxfxcxdxbxegedabagacad

alias ls="ls -G"
alias ll="ls -lh"
alias la="ls -la"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

test -e "${HOME}/.iterm2_shell_integration.bash" \
    && source "${HOME}/.iterm2_shell_integration.bash"

if [[ -n "$TMUX" ]]
then
    exec fish
fi
