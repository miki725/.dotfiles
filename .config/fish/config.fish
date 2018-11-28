set -gx ANDROID_HOME /usr/local/opt/android-sdk
set -gx LANG en_US.utf-8

set -l path \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/go/bin \
    $HOME/Library/Python/3.7/bin \
    /usr/local/opt/python/libexec/bin \
    /usr/local/bin \
    /usr/local/sbin \
    $HOME/.pyenv/shims \
    /usr/local/opt/coreutils/libexec/gnubin

for i in $path[-1..1]
    if test -d $i
        set -gx PATH $i $PATH
    end
end

if test (python3 -m virtualfish 2> /dev/null)
    eval (python3 -m virtualfish auto_activation compat_aliases projects)
end
if test (which direnv)
    eval (direnv hook fish)
end

set -gx manpath \
    /usr/local/opt/coreutils/libexec/gnuman

for i in $manpath[-1..1]
    if test -d $i
        set -gx MANPATH $i $MANPATH
    end
end

if test -e $HOME/.iterm2_shell_integration.fish
    source $HOME/.iterm2_shell_integration.fish
end

if test (which itermocil)
    complete -c itermocil -a "(itermocil --list)"
end

if test -d $HOME/.ssh
    cat $HOME/.ssh/*.config > $HOME/.ssh/.config
end

fortune | cowsay

