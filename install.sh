#!/bin/bash
echo "[*] Installing jsXploiter tools..."

# Go tools
go install github.com/lc/gau@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

# Python libs
pip install requests jsbeautifier

# Setup directory
mkdir -p $HOME/jsXploiter
cd $HOME/jsXploiter

# Download core
curl -s -O https://raw.githubusercontent.com/H4mzaX/jsXploiter/main/jsXploiter.sh
curl -s -O https://raw.githubusercontent.com/H4mzaX/jsXploiter/main/jsScanner.py
chmod +x jsXploiter.sh

echo "✅ Installed at: $HOME/jsXploiter"
echo "▶️ Run: ./jsXploiter.sh https://target.com"
