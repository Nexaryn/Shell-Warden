#!/bin/bash

[[ $EUID -ne 0 ]] && echo "[-] Run as root" && exit 1

DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$DIR/reports/audit-$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$DIR/reports"

passed=0
total=0
risk_score=0
reasons=""

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

    fail_lines=$(echo "$output" | grep '\[FAIL\]')
    if [ -n "$fail_lines" ]; then
        while IFS= read -r line; do
            clean=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
            reasons="$reasons$clean"$'\n'
        done <<< "$fail_lines"
    fi

    if [ $result -eq 0 ]; then
        echo -e "\033[0;32m[PASS]\033[0m"
        ((passed++))
    else
        echo -e "\033[0;31m[FAIL]\033[0m"
    fi
done

echo "Score: $passed/$total" | tee -a "$LOG"
echo "Risk score: $risk_score (0 is best, lower is better)" | tee -a "$LOG"

if [ -n "$reasons" ]; then
    echo "" | tee -a "$LOG"
    echo "Why you lost points:" | tee -a "$LOG"
    echo "$reasons" | grep -v '^$' | sed 's/^/  /' | tee -a "$LOG"
fi

echo "Saved to: $LOG"
