function recreate-pacman-keys --description 'recreate all pacman keys from scratch'
    pacman -S archlinux-keyring gnupg
    rm -fr /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate archlinux
    pacman-key --refresh-keys
    pacman -Su
end
