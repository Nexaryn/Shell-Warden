#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if ufw status | grep -q "Status: active"; then
  echo -e "[PASS] ${GREEN}Firewall is enabled${NC}"
else 
  echo -e "[FAIL] ${RED}Firewall is disabled${NC}"
fi
