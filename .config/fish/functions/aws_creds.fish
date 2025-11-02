function aws_creds
    uv run (echo '
# /// script
# dependencies = [
#   "boto3",
# ]
# ///
import boto3
s = boto3.Session()
c = s.get_credentials().get_frozen_credentials()
print(f"""
set -fx AWS_REGION {s.region_name}
set -fx AWS_ACCESS_KEY_ID {c.access_key}
set -fx AWS_SECRET_ACCESS_KEY {c.secret_key}
set -fx AWS_SESSION_TOKEN {c.token}
set -fe AWS_PROFILE
""")
    ' | psub -s .py) | source
    if test -n "$argv"
        $argv
    end
end
