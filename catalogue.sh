script_location=$(pwd)
set -e
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
useradd roboshop
mkdir -p /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
rm -rf /app/*
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
cp $script_location/files/catalogue.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
cp $script_location/files/mongod.conf /etc/yum.repos.d/mongo.repo
dnf install mongodb-org-shell -y
mongo --host localhost </app/schema/catalogue.js

