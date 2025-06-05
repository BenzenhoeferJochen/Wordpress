#!/bin/bash
yum update -y
yum install -y php php-mysqlnd mariadb105-server unzip httpd
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
sudo mysql -p -u root

CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'DqVBNijQZlVqF0YVMDCC';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
Exit;
cp wp-config-sample.php wp-config.php
sed -i "/DB_NAME/c\define('DB_NAME', 'wordpress');'" wp-config.php
sed -i "/DB_USER/c\define('DB_USER', 'wpuser');" wp-config.php
sed -i "/DB_PASSWORD/c\define('DB_PASSWORD', 'DqVBNijQZlVqF0YVMDCC');" wp-config.php
sed -i "/DB_HOST/c\define('DB_HOST', 'localhost');" wp-config.php