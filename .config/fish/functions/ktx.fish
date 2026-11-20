function ktx --description 'Switch kube context for this shell only'
    # list contexts from the real kubeconfig, not our per-shell copy
    set -l base $KUBECONFIG
    if test "$KUBECONFIG" = "$__ktx_file"
        set base $KTX_BASE
    end

    set -l contexts (KUBECONFIG=$base kubectl config get-contexts -o name 2>/dev/null)
    if test -z "$contexts"
        echo "ktx: no kubeconfig contexts found" >&2
        return 1
    end

    set -l ctx (printf '%s\n' $contexts \
        | fzf --popup center,80%,60% --height 40% --select-1 --query "$argv" --preview "KUBECONFIG=$base kubectl config view --minify --context {}")
    if test -z "$ctx"
        return 1
    end

    __ktx_switch $ctx; or return 1
    echo "switched to $ctx"
end
