#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}  #if not provided as 14 days
LOGS_FOLDER="/var/log/shell-roboshop-common"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"


mkdir -p $LOGS_FOLDER

echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: please use root access"
    exit 1  # failure is other than 0
fi

USAGE(){
    echo -e "$R USAGE:: sudo sh backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS> $N"
    exit 1
}

if [ $# -lt 2 ]; then
    USAGE
fi

if [ ! -d $SOURCE_DIR ]; then
    echo -e "$R ERROR:: Source directory $SOURCE_DIR doesn't exist $N"
    exit 1
fi

if [ ! -d $DEST_DIR ]; then
    echo -e "$R ERROR:: Destnation directory $DEST_DIR doesn't exist $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)

if [ ! -z "${FILES}" ]; then
    echo "Files found: $FILES"
    TIMESTAMP=$(date +%F-%H-%M)
    ZIP_FILENAME="$DEST_DIR/app-logs-$TIMESTAMP.zip"
    echo "zip file name: $ZIP_FILENAME"
    find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS | zip -@ -j "$ZIP_FILENAME"
else
    echo -e "No files to archive .... $Y sipping $N"
fi 

