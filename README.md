# Linux Security Auditor

Automated security audit tool for Ubuntu/Debian servers.
Checks vital security controls and generates a PASS/FAIL report.

## Usage
chmod +x audit.sh checks/*.sh
sudo ./audit.sh

## What it checks
- SSH hardening (Root login, Password Auth, Port)
- Firewall status (UFW enabled/disabled)  
- File permissions (World-writable files in /etc and /tmp, SUID binaries)
- User accounts (Empty passwords in /etc/shadow, unattended-upgrades)

## Sample output
[PASS] SSH root login disabled
[FAIL] Firewall is not active  ← fix this
[PASS] No world-writable files in /etc
