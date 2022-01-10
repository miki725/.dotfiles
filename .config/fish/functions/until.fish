function until --description 'run command until it suceeds'
    while ! eval $argv
        sleep 1
    end
end
