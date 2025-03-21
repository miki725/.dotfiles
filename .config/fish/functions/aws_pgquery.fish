function aws_pgquery
    argparse \
        h/help \
        'e/env=!test -n "$_flag_value"' \
        'u/user=!test -n "$_flag_value"' \
        'd/db=!test -n "$_flag_value"' \
        'p/endpoint=!test -n "$_flag_value"' \
        -- $argv
    or return 1

    if test $_flag_help
        echo "aws_pgquery [-e/--env=] [-p/--endpoint=] -u/--user= -d/--db="
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
    set -l sql "$argv[1]"
    if test -z "$sql"; and not status --is-interactive
        echo sql is required
        return 1
    end

    set -l secret (
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
    function __query
        aws rds-data execute-statement \
            --resource-arn="$argv[1]" \
            --secret-arn=$argv[2] \
            --database=$argv[3] \
            --sql="$argv[4]" \
            --cli-read-timeout=600 \
            | jq 'if .records != null then .records[] else . end'
    end
    if test -n "$sql"
        __query "$cluster" "$secret" "$_flag_db" "$sql"
    else
        while read -l -P "$_flag_user@$_flag_env/$_flag_db> " sql
            __query "$cluster" "$secret" "$_flag_db" "$sql"
        end
    end
end
