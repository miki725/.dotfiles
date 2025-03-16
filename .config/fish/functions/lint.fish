function lint --description 'run pre-commit lint on all changes files'
    argparse -i a/all d/diff -- $argv
    set -l diff
    if test -n "$_flag_diff"
        set diff --show-diff-on-failure
    end
    if test -z "$_flag_all"
        set -l files
        set -l args
        for i in $argv
            if test -e $i
                set files $files $i
            else
                set args $args $i
            end
        end
        if test -z "$files"
            set files (git status --short | awk '{print $2}')
        end
        if test -n "$files"
            pre-commit run $args --files $files $diff
        else
            pre-commit run $args $diff
        end
    else
        pre-commit run $argv --all-files $diff
    end
end
