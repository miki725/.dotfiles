function killgrep --argument pattern
    set pattern $argv[1]
    ps aux | grep $pattern | grep -v grep | awk '{print $2}' | xargs --no-run-if-empty kill
end
