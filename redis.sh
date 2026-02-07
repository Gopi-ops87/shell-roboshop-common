#!/bin/bash

bash ./common.sh

check root

dnf module disable redis -y  &>>$LOG_FILE
VALIDATE $? "Disabling redis"
dnf module enable redis:7 -y  &>>$LOG_FILE
VALIDATE $? "enabling redis 7"
dnf install redis -y   &>>$LOG_FILE
VALIDATE $? "Installing redis"
sed -i \
 -e 's/^bind 127.0.0.1/bind 0.0.0.0/' \
  -e 's/^protected-mode yes/protected-mode no/' \
  /etc/redis/redis.conf &>>$LOG_FILE
VALIDATE $? "allowing remote connections"
systemctl enable redis  &>>$LOG_FILE
VALIDATE $? "enabling redis"
systemctl start redis  &>>$LOG_FILE
VALIDATE $? "Starting Redis"

print_total_time