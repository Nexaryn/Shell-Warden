#!/bin/bash

[[ $EUID -ne 0 ]] && echo "[-] Run as root" && exit 1

DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$DIR/reports/audit-$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$DIR/reports"

passed=0
total=0
risk_score=0

echo "[+] Audit Started" | tee -a "$LOG"

for s in "$DIR/checks"/*.sh; do
    [[ -f "$s" ]] || continue
    ((total++))
    name=$(basename "$s" .sh)

    echo -n "Checking $name... "

    output=$("$s" 2>&1)
    result=$?
    echo "$output" >> "$LOG"

    crit=$(echo "$output" | grep -c '\[CRITICAL\]')
    high=$(echo "$output" | grep -c '\[HIGH\]')
    med=$(echo "$output" | grep -c '\[MEDIUM\]')
    low=$(echo "$output" | grep -c '\[LOW\]')
    risk_score=$((risk_score + crit*10 + high*5 + med*3 + low*1))

    if [ $result -eq 0 ]; then
        echo -e "\033[0;32m[PASS]\033[0m"
        ((passed++))
    else
        echo -e "\033[0;31m[FAIL]\033[0m"
    fi
done

echo "Score: $passed/$total" | tee -a "$LOG"
echo "Risk score: $risk_score (Lower is better)" | tee -a "$LOG"
echo "Saved to: $LOG"
