source common.sh
if [ -z "${roboshop_mysql_password}" ]; then
  echo "Variable roboshop_mysql_password is needed"
  exit
fi
component=dispatch

GOLANG