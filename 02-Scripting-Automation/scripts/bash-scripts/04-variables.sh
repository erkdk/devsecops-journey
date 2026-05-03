#!/bin/bash

# Some variables are environment variables.

NAME='erkdk' # this variable is also kept in ~/.bashrc file in my case.

echo "Date: "
date			# date command
echo
echo " Host-name: " $HOSTNAME
echo " User-name: " $USER
echo " My GitHub account name is $NAME" # displays exported variable from ~/.bashrc file.
echo " Line No. " $LINENO
echo " Your lucky no. may be " $RANDOM
sleep 2s
echo " The Process ID of current running shell: " $$
echo " Time taken: $SECONDS"
echo "Exit code of Last command: $?"


# Notice the difference between quotes '' & ""
course='DevSecOps'
echo 'Course name: $course'
echo "Course name: $course"
