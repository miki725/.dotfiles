function filter_valid_paths
    while read line
        if test -d $line
            echo $line
        end
    end
end

function generate_path

    echo -n "\
$HOME/.local/bin
$HOME/.cargo/bin
$HOME/.yarn/bin
$HOME/.n/bin
$HOME/go/bin
$HOME/.config/yarn/global/node_modules/.bin
" | filter_valid_paths

    if test -d $HOME/Library/Python
        find $HOME/Library/Python/ -name bin -type d | sort -r
    end

    if test -d $HOME/.pyenv/versions
        find $HOME/.pyenv/versions -maxdepth 2 -name bin -type d | sort -r
    end

    echo -n "\
/usr/local/bin
/usr/local/sbin
" | filter_valid_paths

    if test -d /usr/local/opt
        find -L /usr/local/opt -type d -name '*bin' \
            | grep -v '/node_modules/' \
            | grep -v '/gems/' \
            | sort
    end

    if test -d /usr/local/Cellar
        find -L /usr/local/Cellar -maxdepth 3 -type d -name '*bin' \
            | grep -v '/node_modules/' \
            | grep -v '/gems/' \
            | sort
    end

    echo -n "\
/Library/TeX/texbin
/usr/bin
/bin
/usr/sbin
/sbin
" | filter_valid_paths

end
