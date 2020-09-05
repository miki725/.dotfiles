function allcowsay
    for i in (cowsay -l | tail -n+2 | tr " " "\n"); echo Hello by $i |cowsay -f $i; end
end
