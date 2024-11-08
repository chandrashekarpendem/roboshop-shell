
source common.sh

print_head "downloading redis.repo file ro"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG
status_check

print_head "Enable Redis 6.2 from package streams "
dnf module enable redis:remi-6.2 -y &>>$LOG
status_check

print_head "installing redis"
yum install redis -y &>>$LOG
status_check

print_head "changing listening address to 0.0.0.0  "
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  /etc/redis/redis.conf  &>>$LOG
status_check

print_head "enabling redis "
systemctl enable redis &>>$LOG
status_check

print_head " start redis "
systemctl start redis &>>$LOG
status_check
