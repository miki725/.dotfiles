function aws_s3_edit
    set bucket $argv[1]
    set key $argv[2]
    set tmp (mktemp)
    aws s3 cp s3://$bucket/$key $tmp --quiet
    $EDITOR $tmp
    aws s3 cp $tmp s3://$bucket/$key $argv[3..-1]
end
