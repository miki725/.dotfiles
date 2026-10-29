# remove the per-shell kubeconfig written by ktx
function __ktx_cleanup --on-event fish_exit
    if test -n "$__ktx_file"
        rm -f $__ktx_file
    end
end
