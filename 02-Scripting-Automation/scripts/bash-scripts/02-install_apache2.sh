#!/bin/bash

# This script installs apache2 package and starts the service.

echo" ---Installing apache2 web server package---"

sudo apt update

sudo apt install -y apache2     # -y is for default yes

sudo systemctl start apache2

# sudo systemctl enable apache2 #This line ensures apache2 starts on when machine boots.

echo " Hello DevOps World! " > /var/www/html/index.html

sudo systemctl restart apache2


