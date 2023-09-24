function aws_gopass --description 'use gopass TOTP to mfa to AWS profile'
    gopass totp -o (aws configure get gopass) | aws-mfa
end
