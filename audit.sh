#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./audit.sh)"
  exit 1
fi

echo "Welcome to Linux Security Auditor"[cite: 4]
echo "Starting audit..."

LOG_DIR="./reports"
mkdir -p "$LOG_DIR"
REPORT_FILE="$LOG_DIR/audit-$(date +%F-%H%M%S).log"

{
  echo "--- Linux Security Audit Report ---"
  echo "Date: $(date)"
  echo "-----------------------------------"
  
  ./checks/ssh.sh
  ./checks/firewall.sh
  ./checks/files.sh
  ./checks/user.sh
  
} | tee "$REPORT_FILE"

PASS_COUNT=$(grep -c "\[PASS\]" "$REPORT_FILE")
TOTAL_COUNT=$(grep -E -c "\[PASS\]|\[FAIL\]" "$REPORT_FILE")

echo "-----------------------------------" | tee -a "$REPORT_FILE"
echo "Final score: $PASS_COUNT/$TOTAL_COUNT checks passed." | tee -a "$REPORT_FILE"
echo "Report saved to: $REPORT_FILE"
