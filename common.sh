#!/bin/bash

USER_ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop-common"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)

mkdir -p $LOGS_FOLDER

echo "script started executed at: $(date)" | tee -a $LOG_FILE

check_root(){
    if [ $USER_ID -ne 0 ]; then
       echo "ERROR:: please use root access"
       exit 1  # failure is other than 0
    fi
}



VALIDATE() {   #function to receive inputs through args just like shell script args
            if [ $1 -ne 0 ]; then
                echo -e "$2 ....$R failure $N" | tee -a $LOG_FILE
                exit 1
            else
                echo -e "$2.. $G  success $N" | tee -a $LOG_FILE
            fi
}


print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$((END_TIME - START_TIME))
    echo -e "Total execution time is: $Y $TOTAL_TIME seconds $N"
}
