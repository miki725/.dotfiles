function lint --description 'run pre-commit lint on all changes files'
    argparse -i a/all -- $argv
    if test -z "$_flag_all"
        pre-commit run $argv --files (git status --short | awk '{print $2}') --show-diff-on-failure
    else
        pre-commit run $argv --all-files
    end
end
