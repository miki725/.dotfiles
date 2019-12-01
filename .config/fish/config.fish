set -gx ANDROID_HOME /usr/local/opt/android-sdk
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/.ripgreprc
set -gx LANG en_US.UTF-8
set -gx EDITOR vim
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -gx SSH_AGENT_PID ""
set -gx N_PREFIX $HOME/.n

if which starship > /dev/null 2>&1
    starship init fish | source
end

gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1

# modify macOS system SSH_AUTH_SOCK if it does not match
# only for non-root user
if which launchctl > /dev/null 2>&1
        and test (id -u) -gt 0
        and test (launchctl asuser (id -u) launchctl getenv SSH_AUTH_SOCK) != $SSH_AUTH_SOCK
    launchctl asuser (id -u) launchctl setenv SSH_AUTH_SOCK (echo $SSH_AUTH_SOCK)
end

alias l="ls -la"
alias fish_config.fish="vim ~/.config/fish/config.fish"
if which nvim > /dev/null 2>&1
    alias vim=nvim
end

if not contains $HOME/.fish-path-hook $PATH
    set -gx PATH $PATH $HOME/.fish-path-hook

    set path \
        $HOME/.local/bin \
        $HOME/.cargo/bin \
        $HOME/.yarn/bin \
        $HOME/.n/bin \
        $HOME/go/bin \
        $HOME/Library/Python/3.7/bin \
        $HOME/.config/yarn/global/node_modules/.bin \
        /usr/local/bin \
        /usr/local/sbin \
        /usr/local/opt/python/libexec/bin \
        /usr/local/opt/coreutils/libexec/gnubin \
        /usr/local/opt/curl/bin \
        /usr/local/opt/openssl@1.1/bin \
        /usr/local/opt/openssl/bin \
        /usr/local/opt/gettext/bin \
        /usr/local/opt/findutils/libexec/gnubin \
        /usr/local/opt/gnu-sed/libexec/gnubin \
        /usr/local/opt/gnu-tar/libexec/gnubin \
        /usr/local/opt/gnu-which/libexec/gnubin \
        /usr/local/opt/grep/libexec/gnubin \
        /usr/local/opt/ruby/bin \
        /Library/TeX/texbin

    if test -d $HOME/.pyenv/versions
        for i in (find ~/.pyenv/versions/ -depth 2 -name bin -type d)
            set -a path $i
        end
    end

    for i in $path[-1..1]
        # remove duplicates
        # cant simply use contains condition since order could be changed
        # better to remove and then add back to PATH
        while contains $i $PATH
            set -e PATH[(contains -i $i $PATH)]
        end
        if test -d $i
            set -gx PATH $i $PATH
        end
    end

    # sometimes within subshell when VIRTUAL_ENV is already set
    # above PATH adjustements will put VIRTUAL_ENV not on top of PATH
    # hence ignoring most of PATH order
    if set -q VIRTUAL_ENV; and contains $VIRTUAL_ENV/bin $PATH
        set -e PATH[(contains -i $VIRTUAL_ENV/bin $PATH)]
        set -gx PATH $VIRTUAL_ENV/bin $PATH
    end
end

if ! test -e $HOME/.manpath
    generate_manpath > $HOME/.manpath
end
for i in (cat $HOME/.manpath)
    if test -d $i
        set -gx MANPATH $i $MANPATH
    end
end

set -l compilepath \
    /usr/local/opt/openssl@1.1 \
    /usr/local/opt/gmp

for i in $compilepath[-1..1]
    if test -d $i/lib
            and not echo $LDFLAGS | grep $i/lib > /dev/null
        set -gx LDFLAGS "-L$i/lib $LDFLAGS"
    end
    if test -d $i/include
            and not echo $CPPFLAGS | grep $i/include > /dev/null
        set -gx CPPFLAGS "-I$i/include $CPPFLAGS"
    end
    if test -d $i/lib/pkgconfig
            and not echo $PKG_CONFIG_PATH | grep $i/lib/pkgconfig > /dev/null
        set -gx PKG_CONFIG_PATH "$i/lib/pkgconfig:$PKG_CONFIG_PATH"
    end
end

set -l virtualfish_plugins auto_activation compat_aliases projects
if ! test -e $HOME/.virtualfish.fish
        and which python3 > /dev/null 2>&1
        and python3 -m virtualfish > /dev/null 2>&1
    python3 -m virtualfish $virtualfish_plugins > $HOME/.virtualfish.fish
end
if ! test -e $HOME/.virtualfish.fish
        and test -e $HOME/.local/pipx/venvs/virtualfish/bin/python > /dev/null 2>&1
        and $HOME/.local/pipx/venvs/virtualfish/bin/python -m virtualfish > /dev/null 2>&1
    $HOME/.local/pipx/venvs/virtualfish/bin/python -m virtualfish $virtualfish_plugins > $HOME/.virtualfish.fish
end
if test -e $HOME/.virtualfish.fish
    source $HOME/.virtualfish.fish
end

if which direnv > /dev/null 2>&1
    eval (direnv hook fish)
end

if test -e $HOME/.iterm2_shell_integration.fish
    source $HOME/.iterm2_shell_integration.fish
end

if test -f /usr/local/share/chtf/chtf.fish
    source /usr/local/share/chtf/chtf.fish
end

if which itermocil > /dev/null 2>&1
    complete -c itermocil -a "(itermocil --list)"
end

if test -d $HOME/.ssh
    cat $HOME/.ssh/*.config > $HOME/.ssh/.config
end

if which src-hilite-lesspipe.sh > /dev/null 2>&1
    set -gx LESSOPEN "| src-hilite-lesspipe.sh %s"
    set -gx LESS " -R "
end

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if which fortune > /dev/null 2>&1
        and which cowsay > /dev/null 2>&1
        and status --is-interactive
    fortune -s | cowsay
end
