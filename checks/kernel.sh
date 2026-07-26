#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

UPDATES=$(apt-get -s upgrade 2>/dev/null | grep -i "security" | wc -l)
if [ "$UPDATES" -gt 0 ]; then
    echo -e "[FAIL][MEDIUM] ${RED}$UPDATES pending security updates not installed${NC}"
else
    echo -e "[PASS] ${GREEN}No pending security updates${NC}"
fi

COREDUMP=$(ulimit -c)
if [ "$COREDUMP" = "0" ]; then
    echo -e "[PASS] ${GREEN}Core dumps are disabled${NC}"
else
    echo -e "[FAIL][LOW] ${RED}Core dumps are enabled (ulimit -c = $COREDUMP)${NC}"
fi
