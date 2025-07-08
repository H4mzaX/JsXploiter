# 🕵️‍♂️ jsXploiter — JavaScript Secrets Recon Toolkit

> 🔍 Advanced recon tool to extract secrets from public JavaScript files (API keys, tokens, credentials).  
> Built for bug bounty hunters, pentesters, and OSINT warriors.

![License](https://img.shields.io/badge/license-MIT-green)  
![Platform](https://img.shields.io/badge/platform-Termux%20%7C%20Linux%20%7C%20Mac-lightgrey)  
![Status](https://img.shields.io/badge/Status-🔥%20Active-red)

---

## ⚙️ Features
- 🔁 One-line installer (curl | bash)
- 🧠 Uses `gau`, `waybackurls`, and on-page crawling for JS discovery
- 🌐 Filters only **live** JavaScript files
- 🔍 Extracts secrets using regex (AWS keys, Google API, JWT, etc.)
- 🧰 Outputs clean logs to file
- 🧩 Easy to customize or extend

---

## 🚀 Install & Run (1 Command)
```bash
bash <(curl -s https://raw.githubusercontent.com/H4mzaX/jsXploiter/main/install.sh)
```

---

## 🛠 Dependencies
Make sure you have:
- `go` installed (`sudo apt install golang`)
- `python3`, `pip`, and `curl`

```bash
go install github.com/lc/gau@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
pip install requests jsbeautifier
```

---

## 🧪 Usage
```bash
cd $HOME/jsXploiter
./jsXploiter.sh https://target.com
```

Output saved to:
```
jsXploiter_output/secrets.txt
```

---

## 📚 Scans For:
- AWS Access Keys
- Google API Keys
- Slack Tokens
- Stripe Secrets
- Bearer Tokens
- JWTs
- Generic API keys

---

## 🧠 Hacker Tips
- Combine with `gf`, `nuclei`, `katana` or Burp Suite
- Run via VPS for stealth recon
- Feed it your own JS URLs list

---

## 📎 Author
Made by [`@H4mzaX`](https://github.com/H4mzaX)  
Pull requests and stars are welcome 🔥

---

## ⚖️ License
MIT — do anything you want, but don't blame the dev if you get blocked 😉
