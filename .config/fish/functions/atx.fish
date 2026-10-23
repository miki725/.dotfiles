function atx --description "switch AWS_PROFILE via fzf selection"
    set -l profile (aws configure list-profiles | sort | fzf --query "$argv" --select-1 --header "AWS_PROFILE=$AWS_PROFILE")
    or return
    set -gx AWS_PROFILE $profile
    echo "AWS_PROFILE=$AWS_PROFILE"
end
