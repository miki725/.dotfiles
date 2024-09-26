function tosh --description 'mosh into server and attach tmux session or open new one'
    reset
    ssh $argv fish --login --interactive -c tmuxa
end
