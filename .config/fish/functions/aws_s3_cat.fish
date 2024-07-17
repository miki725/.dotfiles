function aws_s3_cat
    set cmd aws
    if set -q AWS_ENDPOINT_URL
        set cmd awslocal
    end
    if string match "s3://*" $argv[1] >/dev/null
        set uri $argv[1]
    else
        set bucket $argv[1]
        set key $argv[2]
        set uri s3://$bucket/$key
    end
    $cmd s3 cp $uri /dev/stdout --quiet
end
