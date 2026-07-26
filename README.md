```markdown
# 🛡️ Linux Security Auditor

A lightweight, automated security auditing tool designed for Ubuntu and Debian servers. It evaluates core system configurations and generates a straightforward PASS/FAIL report to help you identify vulnerabilities and secure your server quickly.

---

## ⚙️ What It Checks

The auditor runs a suite of tests across four critical security domains:

*   **SSH Hardening:** Verifies that Root login is disabled, Password Authentication is disabled, and a non-default SSH Port is in use.
*   **Firewall Status:** Confirms that the Uncomplicated Firewall (UFW) is active and enabled.
*   **File Permissions:** Scans for dangerous world-writable files in `/etc` and `/tmp`, and flags unusually high numbers of SUID binaries.
*   **User & System Security:** Checks `/etc/shadow` for vulnerable empty user passwords and ensures `unattended-upgrades` is actively applying security patches.

---

## 🚀 Getting Started

Run the following commands in your terminal to execute the auditor. 

> **Note:** Root privileges (`sudo`) are strictly required so the script can accurately read protected system files like `/etc/shadow` and SSH configurations.

1. Make the main script and all check scripts executable:
   ```bash
   chmod +x audit.sh checks/*.sh

```

2. Execute the auditor:
```bash
sudo ./audit.sh

```



---

## 📄 Sample Output

The script outputs results directly to your terminal and automatically saves a timestamped copy of the report for your records.

```text
Welcome to Linux Security Auditor
Starting audit...
--- Linux Security Audit Report ---
Date: Sat Jul 25 23:54:36 IST 2026
-----------------------------------
[PASS] Root login is disabled
[PASS] SSH Password Authentication is disabled
[FAIL] SSH is running on default port 22
[FAIL] Firewall is disabled
[PASS] No world-writable files in /etc
[PASS] No world-writable files in /tmp
[PASS] Normal amount of SUID binaries found (42).
[PASS] No users with empty passwords found
[PASS] Unattended-upgrades is enabled (Auto-patching active)
-----------------------------------
Final score: 7/9 checks passed.
Report saved to: ./reports/audit-2026-07-25-235436.log

```
