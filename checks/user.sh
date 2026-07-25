#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


EMPTY_PASS=$(awk -F: '($2 == "" || $2 == "*") {print $1}' /etc/shadow 2>/dev/null)

if [ -n "$EMPTY_PASS" ] && [ "$EMPTY_PASS" != "*" ]; then
  echo -e "[FAIL] ${RED}Users with empty passwords found in /etc/shadow${NC}"
else
  echo -e "[PASS] ${GREEN}No users with empty passwords found${NC}"
fi


if systemctl is-enabled unattended-upgrades &>/dev/null || \
   (command -v apt-config &>/dev/null && apt-config dump 2>/dev/null | grep -q "Unattended-Upgrade \"1\""); then
  echo -e "[PASS] ${GREEN}Unattended-upgrades is enabled (Auto-patching active)${NC}"
else
  echo -e "[FAIL] ${RED}Unattended-upgrades is NOT enabled${NC}"
fi
