function aws_s3_edit
    if string match "s3://*" $argv[1] >/dev/null
        set uri $argv[1]
        set rest $argv[2..-1]
    else
        set bucket $argv[1]
        set key $argv[2]
        set uri s3://$bucket/$key
        set rest $argv[3..-1]
    end
    set tmp (mktemp)
    aws s3 cp $uri $tmp --quiet
    $EDITOR $tmp
    aws s3 cp $tmp $uri $rest
end
