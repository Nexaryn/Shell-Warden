#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

fail=0

EMPTY_PASS=$(awk -F: '($2 == "") {print $1}' /etc/shadow 2>/dev/null)

if [ -n "$EMPTY_PASS" ]; then
  echo -e "[FAIL][CRITICAL] ${RED}Users with empty passwords: $EMPTY_PASS${NC} -> Fix: run passwd on each one of those users to set a password"
  fail=1
else
  echo -e "[PASS] ${GREEN}No users with empty passwords found${NC}"
fi

exit $fail
