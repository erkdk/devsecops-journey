#!/bin/bash

echo " You can enter any number of arguments. But maximum 9 arguments are displayed at once! "
echo " 0th place argument is filename itself and other are counted as further."
echo " You have typed following arguments: "
echo

echo " 0th place argument:--> $0"
echo " 1st place argument:--> $1"
echo " 2nd place argument:--> $2"
echo " 3rd place argument:--> $3"
echo " 4th place argument:--> $4"
echo " 5th place argument:--> $5"
echo " 6th place argument:--> $6"
echo " 7th place argument:--> $7"
echo " 8th place argument:--> $8"
echo " 9th place argument:--> $9"
echo
echo " No. of arguments:---> $#"
echo " Arguments passed are: $@"


