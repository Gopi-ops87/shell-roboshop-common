#!/bin/bash

#count=$1

#while [ $count -gt 0 ]
#do 
  #echo "Time left: $count"
  #sleep 1
  #count=$((count -1))
#done

#echo "Times up"



while IFS= read -r line; do

    #process each line here
    echo "Processing line: $line"
    #example: you can perform other operation with the file variable
    #for instance;
    #some_command "$line"
    #if [[ "$line" == "specific-syntax" ]]; then
    #echo "found specific text"
    #fi
done < user.sh