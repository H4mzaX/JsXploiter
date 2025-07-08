import sys, re, requests
from jsbeautifier import beautify

INPUT = sys.argv[1]
OUTPUT = sys.argv[2]

patterns = {
    "AWS Key": r"AKIA[0-9A-Z]{16}",
    "Google API": r"AIza[0-9A-Za-z-_]{35}",
    "Stripe Live": r"sk_live_[0-9a-zA-Z]{24}",
    "Slack Token": r"xox[baprs]-[0-9a-zA-Z]{10,48}",
    "Bearer": r"(?i)bearer[\s\:]+[a-zA-Z0-9\-_.]+",
    "Generic API": r"[aA]pi[_-]?(key|token)['\"]?\s*[:=]\s*['\"][A-Za-z0-9\-_]{16,45}['\"]",
    "JWT": r"eyJ[A-Za-z0-9\-_]+?\.[A-Za-z0-9\-_]+?\.[A-Za-z0-9\-_]+"
}

with open(INPUT, 'r') as f, open(OUTPUT, 'w') as out:
    for url in f.readlines():
        url = url.strip()
        try:
            res = requests.get(url, timeout=10, verify=False)
            js = beautify(res.text)
            for name, regex in patterns.items():
                matches = re.findall(regex, js)
                for m in matches:
                    out.write(f"{url} >> {name}: {m}\n")
                    print(f"[!] {name} @ {url}")
        except:
            continue
