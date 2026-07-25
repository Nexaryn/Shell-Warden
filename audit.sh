#!/bin/bash

./checks/files.sh &
./shell-warden/checks/firewall.sh &
./shell-warden/checks/ssh.sh

echo "Welcome"
