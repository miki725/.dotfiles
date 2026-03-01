function aws_docker_login
    set -l account_id (aws sts get-caller-identity --query='Account' --output=text --no-cli-pager)
    set -l region (aws configure get region)
    set -l uri $account_id.dkr.ecr.$region.amazonaws.com
    echo $uri >/dev/stderr
    aws ecr get-login-password | docker login --username AWS --password-stdin $uri
end
