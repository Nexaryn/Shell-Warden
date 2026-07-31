# 🛡️ Shell Warden

A lightweight Linux security auditor, built from scratch in plain Bash. It runs a set of checks against your system, tells you what's wrong in plain English, tells you how to fix it, and gives you a risk score — no dependencies, no config files, just scripts.

![lint](https://github.com/Nexaryn/Shell-Warden/actions/workflows/lint.yml/badge.svg)

---

## 🧠 Why I built this

I'm learning Linux and wanted something more hands-on than just reading hardening checklists, so I built a tool that actually checks my own machine against a basic security baseline. Every check lives in its own file in `checks/`, and `audit.sh` just runs each one and tallies up the results. It doesn't auto-fix anything on purpose — it tells you exactly what's wrong and exactly how to fix it yourself, so you actually learn what's going on instead of just clicking a button.

---

## ✅ Requirements

- Bash
- Root privileges (`sudo`) — needed to read protected files like `/etc/shadow` and the real SSH config


---

## ⚙️ What It Checks

4 categories, 10 individual checks total:

### 🔑 SSH Hardening (`checks/ssh.sh`)
- Root login is disabled
- Password authentication is disabled (key-based login only)
- SSH isn't running on the default port 22

### 🔥 Firewall Status (`checks/firewall.sh`)
- Detects and checks whichever firewall you actually have: **UFW**, **firewalld**, **nftables**, or raw **iptables**
- Flags a system with no active firewall at all

### 📂 File Permissions (`checks/files.sh`)
- World-writable files in `/etc`
- World-writable files in `/tmp`
- World-writable directories missing the sticky bit (the real risk — lets anyone delete/rename other users' files)
- Unusually high number of SUID binaries

### 👤 User Security (`checks/user.sh`)
- Checks `/etc/shadow` for accounts with a truly empty password (locked accounts are correctly ignored)

Every failed check comes tagged with a severity — `CRITICAL`, `HIGH`, `MEDIUM`, or `LOW` — and a one-line fix, so you're never just staring at a red `[FAIL]` wondering what to do next.

---

## 🚀 Getting Started

1. Make everything executable:

   ```bash
   chmod +x audit.sh checks/*.sh
   ```

2. Run it:

   ```bash
   sudo ./audit.sh
   ```

That's it. No flags, no setup, no config files to edit.

---

## 📊 How Scoring Works

Alongside a simple `passed/total` count, you get a **risk score** — a weighted number based on how serious the failures are:

| Severity | Points |
|----------|--------|
| CRITICAL | 10     |
| HIGH     | 5      |
| MEDIUM   | 3      |
| LOW      | 1      |

Lower is better. `0` means every check passed. This exists because a missing firewall (critical) and running SSH on a non-default port (low) shouldn't count the same — the score reflects actual risk, not just a raw pass count.

At the end of the run, you also get a plain breakdown of exactly why you lost points, so the number isn't just a mystery.

---

## 📄 Sample Output

```
[+] Audit Started
Checking user... [PASS]
Checking ssh... [FAIL]
Checking firewall... [PASS]
Checking files... [PASS]

Score: 3/4
Risk score: 5 (0 is best, lower is better)

Why you lost points:
  [FAIL][HIGH] SSH Password Authentication is enabled -> Fix: set 'PasswordAuthentication no' in /etc/ssh/sshd_config, use SSH keys instead

Saved to: ./reports/audit-20260725_235436.log
```

Every run also saves a full timestamped log to `reports/`, so you can look back at past audits later.

---

## 🗂️ Project Structure

```
Shell-Warden/
├── audit.sh          # runs every check, tallies score, saves the log
├── checks/           # one script per check category
│   ├── ssh.sh
│   ├── firewall.sh
│   ├── files.sh
│   └── user.sh
└── reports/          # timestamped logs from every run, auto-created
```

Want to add your own check? Drop a new `.sh` file in `checks/` that prints `[PASS]` / `[FAIL][SEVERITY]` lines and exits `0` on pass, non-zero on fail — `audit.sh` will pick it up automatically, no wiring needed.

---

## 🗺️ Roadmap

- Map checks to actual CIS Benchmark IDs
- Optional config file to turn individual checks on/off
- Docker container checks (exposed ports, containers running as root)

---

## 🤝 Contributing

Issues and PRs are welcome. Please run [ShellCheck](https://www.shellcheck.net/) on any script changes before submitting:

```bash
shellcheck audit.sh checks/*.sh
```

---

## ⭐ Support

If this helped you learn something or secure your own box, a star means a lot — this is a learning project and every bit of feedback helps it get better.
