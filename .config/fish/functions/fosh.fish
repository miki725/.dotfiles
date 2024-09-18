function fosh --description 'mosh into server with fish interactive shell'
    mosh $argv -- fish --login --interactive
end
