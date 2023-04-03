function sshfix
    bass eval (tmux show-env -s)
end

function __sshfix --on-event fish_prompt
    if not set -q SSH_AUTH_SOCK
        return
    end
    if not set -q TMUX
        return
    end
    if not test -S $SSH_AUTH_SOCK
        echo SSH auth socket is out of date. updating >/dev/stderr
        sshfix
    end
end
