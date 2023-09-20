function aws_s3_cat
    set bucket $argv[1]
    set key $argv[2]
    set cmd aws
    if set -q AWS_ENDPOINT_URL
        set cmd awslocal
    end
    $cmd s3 cp s3://$bucket/$key /dev/stdout --quiet
end
