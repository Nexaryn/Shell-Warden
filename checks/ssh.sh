#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

SSHD_CONF="/etc/ssh/sshd_config"

if grep -q "^PermitRootLogin yes" "$SSHD_CONF"; then
  echo -e "[FAIL] ${RED}Root login is enabled, it is a security risk${NC}"
else
  echo -e "[PASS] ${GREEN}Root login is disabled${NC}"
fi

if grep -q "^PasswordAuthentication yes" "$SSHD_CONF"; then
  echo -e "[FAIL] ${RED}SSH Password Authentication is enabled${NC}"
else
  echo -e "[PASS] ${GREEN}SSH Password Authentication is disabled${NC}"
fi

if grep -q "^Port 22" "$SSHD_CONF" || ! grep -q "^Port" "$SSHD_CONF"; then
  echo -e "[FAIL] ${RED}SSH is running on default port 22${NC}"
else
  echo -e "[PASS] ${GREEN}SSH is running on a custom port${NC}"
fi
