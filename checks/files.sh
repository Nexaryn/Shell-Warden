#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

fail=0

ETC_WRITABLE=$(find /etc -xdev -type f -perm -002 2>/dev/null)
if [ -n "$ETC_WRITABLE" ]; then
  echo -e "[FAIL][HIGH] ${RED}World-writable files found in /etc${NC} -> Fix: chmod o-w on each file (find /etc -xdev -type f -perm -002 to list them)"
  fail=1
else
  echo -e "[PASS] ${GREEN}No world-writable files in /etc${NC}"
fi

TMP_WRITABLE=$(find /tmp -xdev -type f -perm -002 2>/dev/null)
if [ -n "$TMP_WRITABLE" ]; then
  echo -e "[FAIL][LOW] ${RED}World-writable files found in /tmp${NC} -> Fix: usually fine for /tmp, but check nothing sensitive is in there"
  fail=1
else
  echo -e "[PASS] ${GREEN}No world-writable files in /tmp${NC}"
fi
BAD_DIRS=$(find /tmp /var/tmp -xdev -type d -perm -002 ! -perm -1000 2>/dev/null)
if [ -n "$BAD_DIRS" ]; then
  echo -e "[FAIL][HIGH] ${RED}World-writable dirs without sticky bit: $BAD_DIRS${NC} -> Fix: chmod +t on each directory"
  fail=1
else
  echo -e "[PASS] ${GREEN}No unsafe world-writable directories found${NC}"
fi

SUID_BINS=$(find /bin /sbin /usr/bin /usr/sbin -xdev -type f -perm -4000 2>/dev/null | wc -l)
if [ "$SUID_BINS" -gt 50 ]; then
  echo -e "[FAIL][MEDIUM] ${RED}High number of SUID binaries found ($SUID_BINS)${NC} -> Fix: run 'find / -perm -4000 2>/dev/null' and remove SUID from anything you don't recognize"
  fail=1
else
  echo -e "[PASS] ${GREEN}Normal amount of SUID binaries found ($SUID_BINS).${NC}"
fi

exit $fail
