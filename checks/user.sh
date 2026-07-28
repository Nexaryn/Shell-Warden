#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

fail=0

EMPTY_PASS=$(awk -F: '($2 == "") {print $1}' /etc/shadow 2>/dev/null)

if [ -n "$EMPTY_PASS" ]; then
  echo -e "[FAIL] ${RED}Users with empty passwords found: $EMPTY_PASS${NC}"
  fail=1
else
  echo -e "[PASS] ${GREEN}No users with empty passwords found${NC}"
fi

if systemctl is-enabled unattended-upgrades &>/dev/null || \
   (command -v apt-config &>/dev/null && apt-config dump 2>/dev/null | grep -q "Unattended-Upgrade \"1\""); then
  echo -e "[PASS] ${GREEN}Unattended-upgrades is enabled (Auto-patching active)${NC}"
else
  echo -e "[FAIL] ${RED}Unattended-upgrades is NOT enabled${NC}"
  fail=1
fi

exit $fail
