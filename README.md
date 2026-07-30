```markdown
# 🛡️ Shell Warden

A lightweight, no-frills security auditing tool for Linux. It checks your machine against a basic hardening baseline and gives you a plain PASS/FAIL report, a risk score, and a plain-English reason for every point you lost.

Works on Debian, Ubuntu, Arch, RHEL/Fedora, and anything else with a standard `/etc/shadow`, `sshd`, and one of the common firewall tools.

---

## Why I built this

I'm learning Linux and wanted something hands-on instead of just reading hardening checklists. This checks my own machine against a small baseline I picked myself. Each check lives in its own file in `checks/`, and `audit.sh` just loops through all of them and adds up the results. Nothing here auto-fixes anything on purpose — it tells you what's wrong and how to fix it, you decide if you want to.

---

## ✅ Requirements

* Root privileges (`sudo`)
* Bash

That's it. No extra packages needed to run the auditor itself — the checks just look at whatever's already on your system (firewall tool, ssh config, file permissions) and adapt to what they find.

---

## ⚙️ What It Checks

**SSH Hardening** (`checks/ssh.sh`)
* Root login disabled
* Password authentication disabled
* SSH not running on the default port 22

**Firewall Status** (`checks/firewall.sh`)
* Checks for an active firewall — tries UFW, then firewalld, then nftables, then falls back to checking iptables rules directly. Works no matter which one your distro uses.

**File Permissions** (`checks/files.sh`)
* World-writable files in `/etc`
* World-writable files in `/tmp`
* World-writable directories missing the sticky bit (the actual dangerous version of that problem)
* Unusually high number of SUID binaries

**User Security** (`checks/user.sh`)
* `/etc/shadow` scanned for accounts with empty passwords

Every failed check comes with a `Fix:` hint telling you the actual command or config change needed — this isn't just a checklist, it tells you what to do about it.

---

## 🚀 Getting Started

1. Make the main script and all check scripts executable:
   ```bash
   chmod +x audit.sh checks/*.sh
   ```

2. Run it:
   ```bash
   sudo ./audit.sh
   ```

Root is required since it needs to read `/etc/shadow` and the real SSH config.

---

## 📄 Sample Output

```
[+] Audit Started
Checking files... [PASS]
Checking firewall... [FAIL]
Checking ssh... [FAIL]
Checking user... [PASS]
Score: 2/4
Risk score: 6 (0 is best, lower is better)

Why you lost points:
  [FAIL][CRITICAL] No firewall tool found or active -> Fix: install ufw (Debian/Ubuntu), firewalld (RHEL/Fedora), or nftables (Arch) and enable it
  [FAIL][LOW] SSH is running on default port 22 -> Fix: add 'Port 2222' (or any port) to /etc/ssh/sshd_config
Saved to: /path/to/reports/audit-20260725_235436.log
```

The risk score adds up points per fail based on severity — CRITICAL is worth 10, HIGH is 5, MEDIUM is 3, LOW is 1. Lower is always better, 0 means everything passed.

Every run also saves a full timestamped log in `reports/`, so you've got a history to look back on.

---

## Roadmap

Nothing planned right now — keeping this focused on the 4 checks it already does well rather than piling on more. If that changes I'll update this.

---

## 🤝 Contributing

Issues and PRs welcome. Run `shellcheck` on any script changes before submitting.
```
