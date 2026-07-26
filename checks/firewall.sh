#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if ufw status 2>/dev/null | grep -q "Status: active"; then
    echo "[PASS] UFW firewall is active"
elif iptables -L 2>/dev/null | grep -q "Chain INPUT"; then
    echo "[PASS] iptables rules are present"
else
    echo "[FAIL] No active firewall detected"
fi
