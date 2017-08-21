eval (python3 -m virtualfish auto_activation compat_aliases projects)
eval (direnv hook fish)

set -gx ANDROID_HOME /usr/local/opt/android-sdk

set -gx PATH /usr/local/bin /usr/local/sbin /usr/local/opt/coreutils/libexec/gnubin $PATH
