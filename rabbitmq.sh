source common.sh

if [ -z "${roboshop_mysql_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is needed"
  exit
fi

print_head " Configure YUM Repos from the script provided by vendor "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
condition_check

print_head " install erlang "
yum install erlang -y &>>${LOG}
condition_check

print_head "downloading packages of rabbittmq  "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
condition_check


print_head "  install rabbitmq-server "
yum install rabbitmq-server -y &>>${LOG}
condition_check

print_head "enable rabbitmq-server  "
systemctl enable rabbitmq-server &>>${LOG}
condition_check

print_head "start rabbitmq-server  "
systemctl start rabbitmq-server &>>${LOG}
condition_check

print_head " add_user roboshop  "
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_mysql_password} &>>${LOG}
fi
condition_check

print_head "  administrator "
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
condition_check

print_head "set_permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
condition_check