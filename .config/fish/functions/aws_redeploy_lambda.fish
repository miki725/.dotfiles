function aws_redeploy_lambda --description="redeploy aws lambda by name"
    set name $argv[1]
    set image (
        aws lambda get-function  \
            --function-name $name \
            | jq -r '.Code.ImageUri'
    )
    echo Redeploying $name lambda with $image
    aws lambda update-function-code \
        --function-name $name \
        --image-uri $image
    aws lambda wait function-updated \
        --function-name $name
end
