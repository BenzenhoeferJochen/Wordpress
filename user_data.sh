#!/bin/bash
yum update -y
yum install -y php php-mysqlnd mariadb unzip httpd
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb
cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -r wordpress/* .
rm -rf wordpress latest.zip
chown -R apache:apache /var/www/html
sed -i sed '/DB_NAME/c\define('DB_NAME', 'wordpress');' wp-config.php
sed -i sed '/DB_USER/c\define('DB_USER', 'admin');' wp-config.php
sed -i sed '/DB_PASSWORD/c\define('DB_PASSWORD', '');' wp-config.php
sed -i sed '/DB_HOST/c\define('DB_HOST', 'localhost');' wp-config.php