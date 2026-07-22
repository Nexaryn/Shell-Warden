#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Choose scanning mode:"
echo "1. Important Directories"
echo "2. The whole system (this might take some time)"
read -p "Enter choice 1 or 2: " CHOICE

if [ "$CHOICE" == "1" ];then
TARGET="/etc /usr/bin /bin /sbin"
echo "Scanning $TARGET"
else
TARGET="/"
echo "Scanning $TARGET"

fi


WRITABLE=$(find $TARGET -xdev -type f -perm -002 2>/dev/null)

if [ -n "$WRITABLE" ] ; then
echo -e "${RED} Writable files found.${NC}"
echo "$WRITABLE"

else 
echo -e "${GREEN} Writable files not found. ${NC}"
fi 
