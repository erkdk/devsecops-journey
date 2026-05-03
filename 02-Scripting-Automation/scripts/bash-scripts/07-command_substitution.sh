#!/bin/bash

# using backticks: ``
IPaddr=`ip addr show`
echo "$IPaddr"
IPv4only=`hostname -I | cut -d" " -f1`
echo "$IPv4only"

# using $()
mem_info=$(free -m)
echo "$mem_info"
file_contents=$(cat ./filename)
echo "Contents of file are: $file_contents"


