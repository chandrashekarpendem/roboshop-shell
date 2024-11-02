script_location=$(pwd)
echo "\e[35m installing Nginx\e[0m"
dnf install nginx -y

echo "\e[35m Remove older default nginx content\e[0m"
rm -rf /usr/share/nginx/html/*

echo "\e[35m Download frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo "\e[35m change to nginx path\e[0m"
cd /usr/share/nginx/html

echo "\e[35m unzipping frontend html content\e[0m"
unzip /tmp/frontend.zip

echo "\e[35m copying the configuration file\e[0m"
cp $script_location/files/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo "\e[35m enabling Nginx\e[0m"
systemctl enable nginx

echo "\e[35m restarting Nginx\e[0m"
systemctl restart nginx