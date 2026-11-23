function claude --wraps claude --description 'claude connected to the nvims in this tmux window'
    # the proxy forwards to whichever nvim runs in the window, see ~/.bin/claude-ide-proxy.py
    set -l proxy
    if set -q TMUX_PANE; and command -q uv
        set proxy (~/.bin/claude-ide-proxy.py $fish_pid | string split ' ')
    end
    if test -z "$proxy[1]"
        command claude $argv
        return
    end
    CLAUDE_CODE_SSE_PORT=$proxy[1] command claude $argv
    set -l code $status
    kill $proxy[2] 2>/dev/null
    return $code
end
