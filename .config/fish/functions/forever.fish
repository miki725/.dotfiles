function forever --description 'run infinite loop forever'
    while true
        eval $argv
        sleep 1
    end
end
