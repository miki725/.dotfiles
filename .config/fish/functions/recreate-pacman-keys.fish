function recreate-pacman-keys --description 'recreate all pacman keys from scratch'
    rm -fr /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate archlinux
    pacman-key --refresh-keys
    pacman -Su
end
