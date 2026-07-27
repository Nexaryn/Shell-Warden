#!/bin/bash

[[ $EUID -ne 0 ]] && echo "[-] Run as root" && exit 1

DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$DIR/reports/audit-$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$DIR/reports"

passed=0
total=0

echo "[+] Audit Started" | tee -a "$LOG"

for s in "$DIR/checks"/*.sh; do
    [[ -f "$s" ]] || continue
    ((total++))
    name=$(basename "$s" .sh)

    echo -n "Checking $name... "
    
    if "$s" >> "$LOG" 2>&1; then
        echo -e "\033[0;32m[PASS]\033[0m"
        ((passed++))
    else
        echo -e "\033[0;31m[FAIL]\033[0m"
    fi
done

echo "Score: $passed/$total" | tee -a "$LOG"
echo "Saved to: $LOG"
