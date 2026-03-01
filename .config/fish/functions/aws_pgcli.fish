#! /usr/bin/env -S fish
function aws_pgcli
    argparse \
        h/help \
        'e/env=!test -n "$_flag_value"' \
        'u/user=!test -n "$_flag_value"' \
        'd/db=!test -n "$_flag_value"' \
        'p/endpoint=!test -n "$_flag_value"' \
        s/psql \
        k/k8s \
        shell \
        -- $argv
    or return 1

    if test $_flag_help
        echo "aws_pgcli [-e/--env=] [-p/--endpoint=] -u/--user= -d/--db= [-s/--psql] [--shell] [-k/--k8s]"
        return 1
    end

    if test -z "$_flag_env"
        set _flag_env test
    end
    if test -z "$_flag_endpoint"
        set _flag_endpoint write
    end
    if test -z "$_flag_user"
        echo --user is required
        return 1
    end
    if test -z "$_flag_db"
        echo --db is required
        return 1
    end

    set -l arn (
        aws resourcegroupstaggingapi get-resources \
            --resource-type-filters=secretsmanager:secret \
            --tag-filters \
                Key=environment,Values=$_flag_env \
                Key=endpoint,Values=$_flag_endpoint \
                Key=username,Values=$_flag_user \
                Key=database,Values=$_flag_db \
            --query='ResourceTagMappingList[].ResourceARN' \
            --output=text
    )
    echo + creds arn: $arn 1>&2 >/dev/stderr
    set -l uri (
        aws secretsmanager \
            get-secret-value \
            --secret-id=$arn \
            --query='SecretString' \
            --output=text \
            | jq '.uri' -r
    )
    set -l image ghcr.io/crashappsec/pgcli
    set -l cmd pgcli
    set -l args "--prompt=\u@$_flag_env/\d> "
    set -l cargs
    if set -q _flag_psql
        set image postgres:alpine
        set cmd psql
        set -e args
    else if set -q _flag_shell
        set -l simple (echo "$uri" | tr / ":" | tr "@" ":")
        set cargs $cargs "--env=PGUSER=$(echo $simple | cut -d: -f4)"
        set cargs $cargs "--env=PGPASSWORD=$(echo $simple | cut -d: -f5)"
        set cargs $cargs "--env=PGHOST=$(echo $simple | cut -d: -f6)"
        set cargs $cargs "--env=PGPORT=$(echo $simple | cut -d: -f7)"
        set cargs $cargs "--env=PGDATABASE=$(echo $simple | cut -d: -f8)"

        set image postgres:alpine
        set cmd bash
        set -e args
        set -e uri
    end
    if set -q _flag_k8s
        kubectl run \
            -it \
            --rm aws-pgcli-(date +%s) \
            --image=$image \
            --command \
            $cargs \
            -- \
            $cmd \
            $args \
            $uri
    else
        docker run \
            -it \
            --init \
            --rm \
            --entrypoint=$cmd \
            -v /tmp:/tmp \
            -v $PWD:$PWD \
            -w $PWD \
            $cargs \
            $image \
            $args \
            $uri
    end
end
if test "$_" != source -a "$_" != "."
    aws_pgcli $argv
end
