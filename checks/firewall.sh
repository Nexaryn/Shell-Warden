#!/bin/bash

GREEN='\033[0.32m'
RED='\033[0.31m'
NC='\033[0m'

if sudo ufw status | grep -q "Status: active" ; then
echo -e "${GREEN} Firewall is enabled ${NC}"

else 
echo -e "${RED} Firewall is disabled ${NC}"

fi
