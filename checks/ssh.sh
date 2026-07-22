#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config; then
echo -e "${RED}Root login is enabled, it is a security risk${NC}"	

else
echo -e "${GREEN}Root login is disabled${NC}"
fi
