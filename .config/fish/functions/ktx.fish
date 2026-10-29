function ktx --description 'Switch kube context for this shell only'
    # remember the real kubeconfig (e.g. from direnv) unless KUBECONFIG is already our per-shell copy
    if test "$KUBECONFIG" != "$__ktx_file"
        set -gx KTX_BASE $KUBECONFIG
    end

    set -l contexts (KUBECONFIG=$KTX_BASE kubectl config get-contexts -o name 2>/dev/null)
    if test -z "$contexts"
        echo "ktx: no kubeconfig contexts found" >&2
        return 1
    end

    set -l ctx (printf '%s\n' $contexts \
        | fzf --popup center,80%,60% --height 40% --select-1 --query "$argv" --preview "KUBECONFIG=$KTX_BASE kubectl config view --minify --context {}")
    if test -z "$ctx"
        return 1
    end

    # one file per shell, reused across switches
    if test -z "$__ktx_file"; or not test -e $__ktx_file
        set -g __ktx_file (mktemp -t ktx.XXXXXX)
        if test -z "$__ktx_file"
            return 1
        end
    end

    if not KUBECONFIG=$KTX_BASE kubectl config view --flatten --minify --context $ctx > $__ktx_file
        return 1
    end

    set -gx KUBECONFIG $__ktx_file
    echo "switched to $ctx"
end
