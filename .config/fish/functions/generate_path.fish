function generate_path
    if test -d /usr/local/opt
        find -L /usr/local/opt -type d -name '*bin' \
            | grep -v '/node_modules/' \
            | grep -v '/gems/' \
            | sort
    end
end
