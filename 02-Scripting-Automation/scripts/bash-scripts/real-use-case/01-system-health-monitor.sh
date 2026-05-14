#! /bin/bash

echo "=== SYSTEM HEALTH ==="

echo " "
echo "Uptime:"
uptime

echo " "
echo "Memory usage:"
free -h 

echo " "
echo "Disk usage:"
df -h

echo " "
echo "CPU Load: "
top -bn1 | grep "load average"

echo " "
echo "Logged in users:"
w