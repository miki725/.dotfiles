function pip -d 'do not allow to use pip outside of virtualenv'
    if not set -q VIRTUAL_ENV
        echo "Cannot use pip outside of virtualenv. Please activate virtualenv or use python<version> -m pip." 1>&2
        return 1
    else
        command pip $argv
    end
end
