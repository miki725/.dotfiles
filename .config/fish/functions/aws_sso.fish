function aws_sso
    aws sso login --use-device-code | python -c '
import sys, re, socket
hostname, _, ips = socket.gethostbyname_ex(socket.gethostname())
ip = ips[0]
url = ""
code = ""
for l in sys.stdin:
    if l.startswith("https:"):
        l = l.replace("127.0.0.1", ip)
        url = l.strip()
    elif re.search(r"\w{4}-\w{4}", l):
        code = l.strip()
    print(l, end="")
    if url and code:
        print()
        print(f"{url}?user_code={code}")
        print()
        code = ""
    '
end
