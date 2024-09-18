function tosh --description 'mosh into server and attach tmux session or open new one'
    mosh $argv -- sh -c 'tmux a || tmux'
end
