function generate_manpath
    if test -d /usr/local/opt
        echo ( \
            for i in ( \
                find -L /usr/local/opt -name '*man*' -xtype d \
                | grep -vP 'man\d' \
                | grep -vi command \
                | grep -vi resources \
                | grep -v '/system/' \
                | grep -v '/include' \
                | grep -v '/src/' \
                | grep -v '/node_modules/' \
                | grep -v '/site-packages/' \
            ); \
                if ls $i | grep -P 'man\d' > /dev/null; \
                    echo "$i"; \
                end; \
            end; \
        ) \
        | tr " " "\n" \
        | sort
    end
end
