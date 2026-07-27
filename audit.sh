#!/bin/bash
set -uo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./audit.sh)"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECKS_DIR="$SCRIPT_DIR/checks"
LOG_DIR="$SCRIPT_DIR/reports"
mkdir -p "$LOG_DIR"
REPORT_FILE="$LOG_DIR/audit-$(date +%F-%H%M%S).log"

echo "Welcome to Linux Security Auditor"
echo "Starting audit..."

CHECKS=(ssh.sh firewall.sh files.sh user.sh kernel.sh)

{
  echo "--- Linux Security Audit Report ---"
  echo "Date: $(date)"
  echo "-----------------------------------"
  for c in "${CHECKS[@]}"; do
    path="$CHECKS_DIR/$c"
    if [ -x "$path" ]; then
      "$path"
    else
      echo "[FAIL] $c missing or not executable"
    fi
  done
} | tee "$REPORT_FILE"

PASS_COUNT=$(grep -c "\[PASS\]" "$REPORT_FILE")
TOTAL_COUNT=$(grep -E -c "\[PASS\]|\[FAIL\]" "$REPORT_FILE")

{
  echo "-----------------------------------"
  echo "Final score: $PASS_COUNT/$TOTAL_COUNT checks passed."
  echo "Report saved to: $REPORT_FILE"
} | tee -a "$REPORT_FILE"

[ "$PASS_COUNT" -eq "$TOTAL_COUNT" ]
