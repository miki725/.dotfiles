set SPACEFISH_PROMPT_ORDER \
    user \
    dir \
    host \
    git \
    venv \
    package \
    node \
    docker \
    aws  \
    exec_time \
    line_sep \
    exit_code \
    char
set -gx ANDROID_HOME /usr/local/opt/android-sdk
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/.ripgreprc
set -gx LANG en_US.UTF-8
set -gx EDITOR vim
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -gx SSH_AGENT_PID ""
gpg-connect-agent updatestartuptty /bye > /dev/null

# modify macOS system SSH_AUTH_SOCK if it does not match
if test (which launchctl) \
    -a (id -u) -gt 0 \
    -a (launchctl asuser (id -u) launchctl getenv SSH_AUTH_SOCK) != $SSH_AUTH_SOCK
    launchctl asuser (id -u) launchctl setenv SSH_AUTH_SOCK (echo $SSH_AUTH_SOCK)
end

alias l="ls -la"
alias vim=nvim

set -l path \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/.yarn/bin \
    $HOME/go/bin \
    $HOME/Library/Python/3.7/bin \
    $HOME/.config/yarn/global/node_modules/.bin \
    /usr/local/bin \
    /usr/local/sbin \
    $HOME/.pyenv/shims \
    /usr/local/opt/python/libexec/bin \
    /usr/local/opt/coreutils/libexec/gnubin \
    /usr/local/opt/coreutils/libexec/gnubi \
    /usr/local/opt/curl/bin \
    /usr/local/opt/openssl/bin \
    /usr/local/opt/gettext/bin \
    /usr/local/opt/gnu-sed/libexec/gnubin \
    /usr/local/opt/gnu-tar/libexec/gnubi \
    /usr/local/opt/gnu-which/libexec/gnubi \
    /usr/local/opt/grep/libexec/gnubin \
    /usr/local/opt/ruby/bin

for i in $path[-1..1]
    if test -d $i
        set -gx PATH $i $PATH
    end
end

if test (which python3 2> /dev/null); and test (python3 -m virtualfish 2> /dev/null)
    eval (python3 -m virtualfish auto_activation compat_aliases projects)
end
if test (which direnv 2> /dev/null)
    eval (direnv hook fish)
end

set -l manpath \
    /usr/local/opt/coreutils/libexec/gnuman

for i in $manpath[-1..1]
    if test -d $i
        set -gx MANPATH $i $MANPATH
    end
end

if test -e $HOME/.iterm2_shell_integration.fish
    source $HOME/.iterm2_shell_integration.fish
end

if test -f /usr/local/share/chtf/chtf.fish
    source /usr/local/share/chtf/chtf.fish
end

if test (which itermocil 2> /dev/null)
    complete -c itermocil -a "(itermocil --list)"
end

if test -d $HOME/.ssh
    cat $HOME/.ssh/*.config > $HOME/.ssh/.config
end

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if test (which fortune 2> /dev/null); and test (which cowsay 2> /dev/null); and status --is-interactive
    fortune -s | cowsay
end
