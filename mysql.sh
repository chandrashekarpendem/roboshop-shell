
source common.sh

component=mysqld

if [ -z "${root_mysql_password}" ]; then
  echo "root_mysql_password is misssing"
  exit
fi

print_head "disable MySQL 8 version."
dnf module disable mysql -y &>>${LOG}
condition_check

print_head "downloading mysql"
cp ${set_location}/files/mysql.repo  /etc/yum.repos.d/mysql.repo &>>${LOG}
condition_check

print_head "installing ${component} "
yum install mysql-community-server -y &>>${LOG}
condition_check

print_head "enabling ${component} "
systemctl enable ${component} &>>${LOG}
condition_check

print_head " start ${component} "
systemctl start ${component} &>>${LOG}
condition_check

print_head "changing  the default root password of ${component} "
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
if [ $? -eq 1 ]; then
  echo password already reset
fi
condition_check

