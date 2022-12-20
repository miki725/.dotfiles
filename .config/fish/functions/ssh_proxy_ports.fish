function ssh_proxy_ports --description="Proxy localhost ports via ssh"
    set -l host $argv[1]
    set -l flags $argv[2..]
    set -l ports
    while test -n "$flags"
        set -l i $flags[1]
        set flags $flags[2..]
        if test $i = --
            break
        end
        set -a ports "-L $i:localhost:$i"
    end
    set -l cmd ssh $host -N -T $ports $flags
    echo $cmd >/dev/stderr
    $cmd
end
