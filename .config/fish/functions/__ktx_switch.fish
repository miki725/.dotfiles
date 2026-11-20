function __ktx_switch --description 'Point this shell at a per-shell copy of a kube context'
    set -l ctx $argv[1]

    # remember the real kubeconfig (e.g. from direnv) unless KUBECONFIG is already our per-shell copy
    if test "$KUBECONFIG" != "$__ktx_file"
        set -gx KTX_BASE $KUBECONFIG
    end

    # one file per shell, reused across switches
    if test -z "$__ktx_file"; or not test -e $__ktx_file
        set -g __ktx_file (mktemp -t ktx.XXXXXX)
        if test -z "$__ktx_file"
            return 1
        end
    end

    if not KUBECONFIG=$KTX_BASE command kubectl config view --flatten --minify --context $ctx > $__ktx_file
        return 1
    end

    set -gx KUBECONFIG $__ktx_file
end
