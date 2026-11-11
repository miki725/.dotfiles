# use the gpg agent when the current ssh agent has no keys, e.g. when the shell started
# while the card was unavailable. never replaces an agent which has keys
function __gpgsshfix --on-event fish_prompt
    if set -q SSH_CONNECTION
        return
    end
    if not set -q __gpg_ssh_sock
        type -q gpgconf; or return
        set -g __gpg_ssh_sock (gpgconf --list-dirs agent-ssh-socket)
    end
    if test "$SSH_AUTH_SOCK" = "$__gpg_ssh_sock"
        return
    end
    ssh-add -l >/dev/null 2>&1
    and return
    SSH_AUTH_SOCK=$__gpg_ssh_sock ssh-add -l >/dev/null 2>&1
    or return
    echo SSH agent has no keys. switching to gpg agent >/dev/stderr
    set -gx SSH_AUTH_SOCK $__gpg_ssh_sock
    set -gx SSH_AGENT_PID ""
    set -gx GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 &
end
