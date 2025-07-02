#!/bin/bash
yum update -y
yum install -y php php-mysqlnd unzip httpd
systemctl start httpd
systemctl enable httpd
cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -r wordpress/* .
rm -rf wordpress latest.zip
chown -R apache:apache /var/www/html
sudo mysql -p -u root

CREATE USER 'wpuser'@'${db_address}' IDENTIFIED BY '${db_password}';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'${db_address}';
FLUSH PRIVILEGES;
Exit;
cp wp-config-sample.php wp-config.php
sed -i "/DB_NAME/c\define('DB_NAME', 'wordpress');'" wp-config.php
sed -i "/DB_USER/c\define('DB_USER', 'wpuser');" wp-config.php
sed -i "/DB_PASSWORD/c\define('DB_PASSWORD', '${db_password}');" wp-config.php
sed -i "/DB_HOST/c\define('DB_HOST', '${db_address}');" wp-config.php