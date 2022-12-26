function aws_creds --description="export aws creds from current profile as env vars"
    set -gx AWS_ACCESS_KEY_ID (aws configure get aws_access_key_id)
    set -gx AWS_SECRET_ACCESS_KEY (aws configure get aws_secret_access_key)
end
