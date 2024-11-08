source common.sh

print_head" copying the repo file "
cp $script_location/files/mongod.conf /etc/yum.repos.d/mongo.repo
status_check

print_head" installing mongodb"
dnf install mongodb-org -y
status_check

print_head" changing port to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check

print_head" enabling mongodb"
systemctl enable mongod
status_check

print_head" restart mongodb"
systemctl restart mongod
status_check