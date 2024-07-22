function aws_sso
    aws sso login | python -c '
import sys, re
url = ""
code = ""
for l in sys.stdin:
    print(l, end="")
    if l.startswith("https:"):
        url = l.strip()
    elif re.search(r"\w{4}-\w{4}", l):
        code = l.strip()
    if url and code:
        print()
        print(f"{url}?user_code={code}")
        print()
        code = ""
    '
end
