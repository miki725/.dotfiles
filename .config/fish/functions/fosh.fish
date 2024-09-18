function fosh --description 'mosh into server with fish interactive shell'
    ssh $argv -- fish --login --interactive
end
