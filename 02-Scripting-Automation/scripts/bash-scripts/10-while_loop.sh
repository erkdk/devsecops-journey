#!/bin/bash

counter=0
while [ $counter -lt 5 ];
do
        echo "Counter - $counter"
        counter=$((counter+1))
        sleep 0.5s
done
echo 'Outside While Loop'

