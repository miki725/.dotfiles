function generate_path

    echo -n "\
$HOME/.local/bin
$HOME/.cargo/bin
$HOME/.yarn/bin
$HOME/.n/bin
$HOME/go/bin
$HOME/Library/Python/3.7/bin
$HOME/.config/yarn/global/node_modules/.bin
/usr/local/bin
/usr/local/sbin
"

    if test -d /usr/local/opt
        find -L /usr/local/opt -type d -name '*bin' \
            | grep -v '/node_modules/' \
            | grep -v '/gems/' \
            | sort
    end

    echo -n "\
/Library/TeX/texbin
"

    if test -d $HOME/.pyenv/versions
        find $HOME/.pyenv/versions -maxdepth 2 -name bin -type d
    end

end
