source common.sh
if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is needed"
  exit
fi
component=dispatch

GOLANG