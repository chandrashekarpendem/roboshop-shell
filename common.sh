script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check () {
if [ $? -eq 0 ]
then
    echo  -e "\e[32m SUCCESS \e[0m"
else
    echo  -e "\e[31m FAILURE \e[0m"
    echo "please refer the log-> ${LOG}"
    exit
fi
}

print_head () {
  echo -e "\e[1m  $1 \e[0m"
}

user1_check () {
  print_head "adding user"
  id roboshop
  if [ $? -ne 0 ]; then
    useradd roboshop
  fi
}

NODEJS() {
  print_head "Disable nodejs"
  dnf module disable nodejs -y
  status_check

  print_head" enable nodejs 18"
  dnf module enable nodejs:18 -y
  status_check

  print_head" install nodejs"
  dnf install nodejs -y
  status_check

  app_preq

  print_head "node packages installing"
  cd /app
  npm install &>>${LOG}
  status_check

  systemd

  schema_load

}

app_preq() {

  user1_check $>>$LOG

  print_head" create app directory"
  mkdir -p /app $>>$LOG
  status_check

  print_head" download catalogue content"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip $>>$LOG
  status_check

  print_head" remove previous app directory content"
  rm -rf /app/* $>>$LOG
  cd /app
  status_check


  print_head" extract catalogue content"
  unzip /tmp/$component.zip $>>$LOG
  cd /app
  status_check

}

systemd () {

  print_head" copy the catalogue service files"
  cp $script_location/files/$component.service /etc/systemd/system/$component.service $>>$LOG
  status_check

  print_head" daemon reload"
  systemctl daemon-reload $>>$LOG
  status_check

  print_head" enable $component service"
  systemctl enable $component $>>$LOG
  status_check

  print_head" start $component service"
  systemctl start $component $>>$LOG
  status_check

}

schema_load () {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo" ]; then
      print_head " copying repo file "
      cp ${set_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
      status_check

      print_head " installing mongod client "
      yum install mongodb-org-shell -y  &>>${LOG}
      status_check

      print_head " loading mongod "
      mongo  --host mongodb-dev.chandrap.shop </app/schema/${component}.js &>>${LOG}
      status_check
    fi

      if [ ${schema_type} == "mysql" ]; then

         print_head " installing mysql  "
         yum install mysql -y   &>>${LOG}
         status_check

         print_head " loading mysql "
         mysql --host mysql-dev.chandrap.shop -uroot -p${root_mysql_password} </app/schema/shipping.sql &>>${LOG}
         status_check
      fi
   fi
}

maven () {
 print_head " installing maven "
 yum install maven -y &>>${LOG}
 status_check

 app_preq

 print_head " clean package command ${component} "
 cd /app
 mvn clean package &>>${LOG}
 status_check

 print_head "moving ${component} files from target folder to app directory "
 mv target/shipping-1.0.jar  shipping.jar &>>${LOG}
 status_check

 systemd

 schema_load

}

python () {
  print_head " installing python "
  yum install python36 gcc python3-devel -y &>>${LOG}
  status_check

 app_preq

 print_head " installing python requirements "
 cd /app
 pip3.6 install -r requirements.txt &>>${LOG}
 status_check

 print_head " update passwords in ${component} file"
 sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/"  ${set_location}/files/${component}.service &>>${LOG}
 status_check

 systemd
}

GOLANG() {

 print_head " installing golang "
 dnf install golang -y $>>$LOG
 status_check

 app_preq

 print_head " inti dispatch"
 go mod init dispatch $>>$LOG
 status_check

 print_head " get go "
 go get $>>$LOG
 status_check

 print_head " build go "
 go build $>>$LOG
 status_check

 systemd
}