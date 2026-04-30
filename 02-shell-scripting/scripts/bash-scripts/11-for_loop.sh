#!/bin/bash

# Display numbers 1 to 5
for x in {1..5};
do
        echo $x
done


# Install 4 packages
PKGS="apache2 wget curl git"
for pkg in $PKGS
do
        echo " Installing $pkg...."
        sudo apt install $pkg
done

