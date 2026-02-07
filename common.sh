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
MONGODB_HOST=mongo.dev28p.online
SCRIPT_DIR=$PWD
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

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disabling nodejs"
    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "enabling nodejs"
    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "installing nodejs"
    
    npm install  &>>$LOG_FILE
    VALIDATE $? "install dependies"
}

app_setup(){
    id roboshop &>> $LOG_FILE
        if [ $? -ne 0 ]; then
            useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
            VALIDATE $? "creating system user"
        else
            echo -e "User already exist ... $Y Skipping $N"
        fi
    mkdir -p /app 
    VALIDATE $? "Creating app directory"
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "Downloading $app_name application"
    cd /app 
    VALIDATE $? "Changing app directory"
    rm -rf /app/*
    VALIDATE $? "Removing existing code"
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "unzip $app_name"
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOG_FILE
    VALIDATE $? "copy systemstl service"
    systemctl daemon-reload
    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "enable $app_name"
}

app_restart(){
    systemctl restart $app_name
    VALIDATE $? "Restarting $app_name"

}


print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$((END_TIME - START_TIME))
    echo -e "Total execution time is: $Y $TOTAL_TIME seconds $N"
}
