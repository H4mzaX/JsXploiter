#!/bin/bash

echo -e "\e[1;36m
   ╔═════════════════════════════╗
   ║    🕵️ jsXploiter Loaded     ║
   ╚═════════════════════════════╝
\e[0m"

# Help section
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "
Usage:
  ./jsXploiter.sh <https://target.com>    # Scan single target
  ./jsXploiter.sh                         # Use urls.txt for bulk scan
  ./jsXploiter.sh --loop                  # Loop scan every 6 hours
  ./jsXploiter.sh --help | -h             # Show this help menu

Output:
- Colored terminal logs
- HTML and JSON reports saved in jsXploiter_output/
"
    exit 0
fi

# Loop mode
if [[ "$1" == "--loop" ]]; then
    while true; do
        echo "[*] 🔄 Running in loop mode (6h interval)"
        ./jsXploiter.sh
        sleep 21600  # 6 hours
    done
fi

echo -e "\e[1;32m[*] jsXploiter - Secrets Recon Scanner\e[0m"
mkdir -p jsXploiter_output
> js_urls_raw.txt

# Input check
if [[ -z "$1" && ! -f "urls.txt" ]]; then
    echo -e "\e[1;31m[!] No input. Run --help for usage.\e[0m"
    exit 1
fi

# Run modes
if [[ ! -z "$1" ]]; then
    domain=$(echo $1 | sed 's~http[s]*://~~g' | cut -d/ -f1)
    echo -e "\e[1;36m[*] Scanning: $domain\e[0m"
    gau $domain 2>/dev/null | grep '\.js' >> js_urls_raw.txt
    waybackurls $domain 2>/dev/null | grep '\.js' >> js_urls_raw.txt
else
    echo -e "\e[1;33m[*] Bulk mode from urls.txt\e[0m"
    while read -r line; do
        domain=$(echo $line | sed 's~http[s]*://~~g' | cut -d/ -f1)
        echo -e "\e[1;36m[*] → $domain\e[0m"
        gau $domain 2>/dev/null | grep '\.js' >> js_urls_raw.txt
        waybackurls $domain 2>/dev/null | grep '\.js' >> js_urls_raw.txt
    done < urls.txt
fi

# Filter live
echo -e "\e[1;35m[*] Checking live JS files...\e[0m"
sort -u js_urls_raw.txt > js_urls.txt
cat js_urls.txt | httpx -silent -mc 200 -t 50 -timeout 5 > live_js.txt

count=$(wc -l < live_js.txt)
echo -e "\e[1;32m[+] Live JS: $count\e[0m"

# Run Python scanner
python3 jsScanner.py live_js.txt jsXploiter_output/secrets.txt

# Convert to HTML and JSON if results found
if [[ -s jsXploiter_output/secrets.txt ]]; then
    echo -e "\e[1;32m[✔] Secrets found. Generating reports...\e[0m"
    awk -F '>>' '{print "{\\\"url\\\": \\\"" $1 "\\\", \\\"secret\\\": \\\"" $2 "\\"},"}' jsXploiter_output/secrets.txt | sed '$s/,$//' | awk 'BEGIN {print "["} {print} END {print "]"}' > jsXploiter_output/secrets.json
    awk '{print "<p>" $0 "</p>"}' jsXploiter_output/secrets.txt > jsXploiter_output/secrets.html
else
    echo -e "\e[1;33m[-] No secrets detected.\e[0m"
fi

echo -e "\e[1;36m[✔] Done → Output in jsXploiter_output/\e[0m"
