function aws_s3_latest_file
    set bucket $argv[1]
    set index $argv[2]
    if test -z "$index"
        set index -1
    end
    set cmd aws
    if set -q AWS_ENDPOINT_URL
        set cmd awslocal
    end
    aws_s3_cat $bucket ($cmd s3api list-objects --bucket $bucket --query "sort_by(Contents, &LastModified)[$index].Key" --output text)
end
