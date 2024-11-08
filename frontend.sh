source common.sh 


print_head  " installing Nginx"
dnf install nginx -y &>>${LOG}
status_check

print_head  " Remove older default nginx content"
rm -rf /usr/share/nginx/html/*  &>>${LOG}
status_check

print_head " Download frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${LOG}
status_check

print_head " change to nginx path"
cd /usr/share/nginx/html  &>>${LOG}
status_check

print_head " unzipping frontend html content"
unzip /tmp/frontend.zip  &>>${LOG}
status_check

print_head " copying the configuration file"
cp $script_location/files/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>${LOG}
status_check

print_head " enabling Nginx"
systemctl enable nginx  &>>${LOG}
status_check

print_head " restarting Nginx"
systemctl restart nginx  &>>${LOG}
status_check