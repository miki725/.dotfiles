function yay
    if test (id -un) = yay
        command yay $argv
    else
        sudo -u yay yay $argv
    end
end
