if test (python3 -m virtualfish 2> /dev/null)
    eval (python3 -m virtualfish auto_activation compat_aliases projects)
end
if test (which direnv)
    eval (direnv hook fish)
end

set -gx ANDROID_HOME /usr/local/opt/android-sdk

set -l path \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/local/opt/coreutils/libexec/gnubin

for i in $path[-1..1]
    if test -d $i
        set -gx PATH $i $PATH
    end
end

set -gx manpath \
    /usr/local/opt/coreutils/libexec/gnuman

for i in $manpath[-1..1]
    if test -d $i
        set -gx MANPATH $i $MANPATH
    end
end
