function kns --description 'Switch kube namespace for this shell only'
    set -l ns (kubectl get ns -o name | string replace namespace/ '' | fzf --popup center,80%,60% --height 40% --select-1 --query "$argv")
    if test -z "$ns"
        return 1
    end

    # set-context edits whatever KUBECONFIG points at, so move to a per-shell
    # copy first or the namespace would change for every shell
    if test "$KUBECONFIG" != "$__ktx_file"
        set -l ctx (command kubectl config current-context)
        or return 1
        __ktx_switch $ctx; or return 1
    end

    if command kubectl config set-context --current --namespace $ns >/dev/null
        echo "namespace $ns"
    end
end
