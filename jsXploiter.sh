#!/bin/bash

echo -e "\e[1;36m
   ╔═════════════════════════════╗
   ║    🕵️ jsXploiter Loaded     ║
   ╚═════════════════════════════╝
\e[0m"
echo "[*] jsXploiter - JavaScript Secrets Recon Tool"
echo "[*] Mode: Single target or Bulk (urls.txt)"
echo "--------------------------------------------"

if [[ -z "$1" && ! -f "urls.txt" ]]; then
    echo "[!] Usage:"
    echo "  ./jsXploiter.sh https://target.com"
    echo "  OR"
    echo "  ./jsXploiter.sh (with urls.txt file in same directory)"
    exit 1
fi

mkdir -p jsXploiter_output
> js_urls_raw.txt

# If single URL given
if [[ ! -z "$1" ]]; then
    domain=$(echo $1 | sed 's~http[s]*://~~g' | cut -d/ -f1)
    echo "[*] 🔍 Scanning $domain ..."
    gau $domain 2>/dev/null | grep '\.js' >> js_urls_raw.txt
    waybackurls $domain 2>/dev/null | grep '\.js' >> js_urls_raw.txt
else
    echo "[*] 🔁 Scanning multiple domains from urls.txt ..."
    while read -r line; do
        domain=$(echo $line | sed 's~http[s]*://~~g' | cut -d/ -f1)
        echo "[*] 🔍 $domain ..."
        gau $domain 2>/dev/null | grep '\.js' >> js_urls_raw.txt
        waybackurls $domain 2>/dev/null | grep '\.js' >> js_urls_raw.txt
    done < urls.txt
fi

echo "[*] ✅ Collected $(wc -l < js_urls_raw.txt) raw JS URLs"
echo "[*] 🔄 Filtering live URLs..."

sort -u js_urls_raw.txt > js_urls.txt
cat js_urls.txt | httpx -silent -mc 200 > live_js.txt

echo "[*] 🌐 Found $(wc -l < live_js.txt) live JS files"
echo "[*] 🚀 Starting secrets scan..."

python3 jsScanner.py live_js.txt jsXploiter_output/secrets.txt

echo "[✔] Completed. Results saved to → jsXploiter_output/secrets.txt"
