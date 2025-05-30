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
        -- $argv
    or return 1

    if test $_flag_help
        echo "aws_pgcli [-e/--env=] [-p/--endpoint=] -u/--user= -d/--db= [-s/--psql] [-k/--k8s]"
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
    if set -q _flag_psql
        set image postgres:alpine
        set cmd psql
        set -e args
    end
    if set -q _flag_k8s
        kubectl run -it --rm aws-pgcli-(date +%s) --image=$image --command -- $cmd $args $uri
    else
        docker run -it --init --rm --entrypoint=$cmd $image $args $uri
    end
end
if test "$_" != source -a "$_" != "."
    aws_pgcli $argv
end
