function aws_s3_cat
    set bucket $argv[1]
    set key $argv[2]
    aws s3 cp s3://$bucket/$key /dev/stdout --quiet
end
