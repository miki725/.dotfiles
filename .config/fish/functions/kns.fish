function kns --description 'Switch kube namespace for this shell only'
    set -l ns (kubectl get ns -o name | string replace namespace/ '' | fzf --popup center,80%,60% --height 40% --select-1 --query "$argv")
    if test -z "$ns"
        return 1
    end

    if kubectl config set-context --current --namespace $ns >/dev/null
        echo "namespace $ns"
    end
end
