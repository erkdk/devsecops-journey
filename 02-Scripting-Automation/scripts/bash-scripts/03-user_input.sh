#!/bin/bash

# read inputs from user
read -p " What is your name? " name
read -p " Where do you live? " add
read -sp " Type your favourite food & ENTER: " food

# display inputs from user
echo
echo " Hmmm... You'r" $name
printf " and You live in $add."
echo
echo " You like $food."

