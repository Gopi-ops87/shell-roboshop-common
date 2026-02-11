#!/bin/bash

count=$1

while [ $count -gt 0 ]
do 
  echo "Time left: $count"
  sleep 1
  count=$((count -1))
done

echo "Times up"