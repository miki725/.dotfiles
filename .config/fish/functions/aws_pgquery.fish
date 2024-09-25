function aws_pgquery
    argparse \
        h/help \
        'e/env=!test -n "$_flag_value"' \
        'u/user=!test -n "$_flag_value"' \
        'd/db=!test -n "$_flag_value"' \
        -- $argv
    or return 1

    if test $_flag_help
        echo "aws_pgquery [-e/-env=] -u/--user= -d/--db= <SQL>"
        return 1
    end

    if test -z "$_flag_env"
        set _flag_env test
    end
    if test -z "$_flag_user"
        echo --user is required
        return 1
    end
    if test -z "$_flag_db"
        echo --db is required
        return 1
    end
    if test -z "$argv[1]"
        echo sql is required
        return 1
    end

    set -l secret (
        aws resourcegroupstaggingapi get-resources \
            --resource-type-filters=secretsmanager:secret \
            --tag-filters Key=environment,Values=$_flag_env Key=username,Values=$_flag_user Key=database,Values=$_flag_db \
            --query='ResourceTagMappingList[].ResourceARN' \
            --output=text
    )
    echo + creds arn: $secret 1>&2 >/dev/stderr
    set -l cluster (
        aws secretsmanager \
            get-secret-value \
            --secret-id=$secret \
            --query='SecretString' \
            --output=text \
            | jq '.cluster' -r
    )
    echo + cluster arn: $cluster 1>&2 >/dev/stderr
    aws rds-data execute-statement \
        --resource-arn=$cluster \
        --secret-arn=$secret \
        --database=$_flag_db \
        --sql="$argv[1]" \
        | jq '.records[]'
end
