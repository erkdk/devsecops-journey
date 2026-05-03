#!/bin/bash

if [ -f /var/run/apache2/apache2.pid ]; then
        echo ' apache2 is running!...'
else
        echo ' apache2 is not running currently!'
        echo ' So, runing apache2!...'
        sudo systemctl start apache2
        echo ' Done! Now, apache2 is running!'
fi

