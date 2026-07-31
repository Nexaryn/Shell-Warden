#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

fail=0

if command -v ufw &>/dev/null && ufw status 2>/dev/null | grep -q "Status: active"; then
    echo -e "[PASS] ${GREEN}UFW firewall is active${NC}"

elif command -v firewall-cmd &>/dev/null && firewall-cmd --state 2>/dev/null | grep -q "running"; then
    echo -e "[PASS] ${GREEN}firewalld is active${NC}"

elif command -v nft &>/dev/null && nft list ruleset 2>/dev/null | grep -q .; then
    echo -e "[PASS] ${GREEN}nftables rules are present${NC}"

elif command -v iptables &>/dev/null; then
    # "Chain INPUT" header always shows up even with zero rules, so check for real rules too
    RULES=$(iptables -L INPUT 2>/dev/null | tail -n +3 | grep -c .)
    POLICY=$(iptables -L INPUT 2>/dev/null | head -1 | grep -o "policy [A-Z]*" | awk '{print $2}')

    if [ "$RULES" -gt 0 ] || [ "$POLICY" != "ACCEPT" ]; then
        echo -e "[PASS] ${GREEN}iptables rules are present (policy: $POLICY, rules: $RULES)${NC}"
    else
        echo -e "[FAIL][CRITICAL] ${RED}iptables loaded but no rules, default policy is ACCEPT${NC} -> Fix: set up ufw, firewalld, or nftables rules depending on your distro"
        fail=1
    fi
else
    echo -e "[FAIL][CRITICAL] ${RED}No firewall tool found or active${NC} -> Fix: install ufw (Debian/Ubuntu), firewalld (RHEL/Fedora), or nftables (Arch) and enable it"
    fail=1
fi

exit $fail
