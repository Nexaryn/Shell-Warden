#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

fail=0
SSHD_CONF="/etc/ssh/sshd_config"

if command -v sshd &>/dev/null; then
  EFFECTIVE=$(sshd -T 2>/dev/null)
else
  EFFECTIVE=$(grep -v '^#' "$SSHD_CONF")
fi

if echo "$EFFECTIVE" | grep -qi "^permitrootlogin yes"; then
  echo -e "[FAIL][CRITICAL] ${RED}Root login is enabled${NC} -> Fix: set 'PermitRootLogin no' in $SSHD_CONF and restart ssh"
  fail=1
else
  echo -e "[PASS] ${GREEN}Root login is disabled${NC}"
fi

if echo "$EFFECTIVE" | grep -qi "^passwordauthentication yes"; then
  echo -e "[FAIL][HIGH] ${RED}SSH Password Authentication is enabled${NC} -> Fix: set 'PasswordAuthentication no' in $SSHD_CONF, use SSH keys instead"
  fail=1
else
  echo -e "[PASS] ${GREEN}SSH Password Authentication is disabled${NC}"
fi

if echo "$EFFECTIVE" | grep -qi "^port 22$"; then
  echo -e "[FAIL][LOW] ${RED}SSH is running on default port 22${NC} -> Fix: add 'Port 2222' (or any port) to $SSHD_CONF"
  fail=1
else
  echo -e "[PASS] ${GREEN}SSH is running on a custom port${NC}"
fi

exit $fail
