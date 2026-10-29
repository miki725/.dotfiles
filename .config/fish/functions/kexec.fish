function kexec --description 'Run a command against every kube context matching a glob'
    # stop at the first non-option so the command keeps its own flags (kexec '*' get pods -o wide)
    argparse --stop-nonopt h/help m/multi -- $argv
    or return 2

    set -l usage "usage: kexec [-m|--multi] [<context-glob>] [--] <command...>
  kexec 'prod*-ro' get nodes         kubectl subcommand on every match
  kexec -m get nodes                 pick contexts with fzf (tab to mark, ctrl-a for all)
  kexec '*-ro' 'env | grep KUBE'     a single quoted argument is a fish snippet"
    if set -q _flag_help
        echo $usage
        return 0
    end

    # same base kubeconfig as ktx: the real one, not ktx's per-shell copy
    set -l base $KUBECONFIG
    if test -n "$__ktx_file"; and test "$KUBECONFIG" = "$__ktx_file"
        set base $KTX_BASE
    end

    set -l contexts (KUBECONFIG=$base kubectl config get-contexts -o name 2>/dev/null)
    if test -z "$contexts"
        echo "kexec: no kubeconfig contexts found" >&2
        return 1
    end

    # the glob is optional: the first argument is one if it has no spaces and
    # either has a * (the only wildcard fish globs support) or is an exact context name
    set -l pattern '*'
    if test (count $argv) -gt 0; and not string match -q -- '* *' $argv[1]
        if string match -q -- '*\**' $argv[1]; or contains -- $argv[1] $contexts
            set pattern $argv[1]
            set -e argv[1]
        end
    end
    if test "$argv[1]" = --
        set -e argv[1]
    end
    set -l cmd $argv
    if test (count $cmd) -eq 0
        echo $usage >&2
        return 2
    end

    set contexts (string match -- $pattern $contexts)
    if test (count $contexts) -eq 0
        echo "kexec: no contexts match $pattern" >&2
        return 1
    end

    if set -q _flag_multi
        set contexts (printf '%s\n' $contexts | fzf --multi --popup center,80%,60% --height 40% \
            --bind 'ctrl-a:select-all,ctrl-d:deselect-all' \
            --header 'tab: mark, ctrl-a: all, ctrl-d: none, enter: run' \
            --preview "KUBECONFIG=$base kubectl config view --minify --context {}")
        if test -z "$contexts"
            return 1
        end
    end

    # a single argument with spaces is a fish snippet: kexec '*-ro' 'env | grep KUBE'
    # anything else that isn't a command is a kubectl subcommand: kexec '*-ro' get nodes
    set -l script
    if test (count $cmd) -eq 1; and string match -q '* *' -- $cmd[1]
        set script $cmd[1]
    else if not type -q $cmd[1]
        set cmd kubectl $cmd
    end

    # each command sees only its context, so any tool (kubectl, helm, k9s, ...) works
    set -l tmp (mktemp -t kexec.XXXXXX)
    if test -z "$tmp"
        return 1
    end
    set -l failed
    for ctx in $contexts
        set_color --bold
        echo "=== $ctx"
        set_color normal
        KUBECONFIG=$base kubectl config view --flatten --minify --context $ctx > $tmp
        begin
            # exported for the whole snippet, including every side of a pipe
            set -lx KUBECONFIG $tmp
            if test -n "$script"
                eval $script
            else
                $cmd
            end
        end
        if test $status -ne 0
            set -a failed $ctx
        end
    end
    rm -f $tmp

    if test (count $failed) -gt 0
        echo "kexec: failed on $failed" >&2
        return 1
    end
end
