#!/bin/bash
yum update -y
yum install -y php php-mysqlnd mariadb105-server unzip httpd
systemctl start httpd
systemctl enable httpd
cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -r wordpress/* .
rm -rf wordpress latest.zip
chown -R apache:apache /var/www/html
sudo mysql -p${db_password} -u root -h ${db_address} wordpress

CREATE USER 'wpuser'@'${db_address}:${db_port}' IDENTIFIED BY '${db_password}';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'${db_address}:${db_port}';
FLUSH PRIVILEGES;
Exit;
cp wp-config-sample.php wp-config.php
sed -i "/DB_NAME/c\define('DB_NAME', 'wordpress');'" wp-config.php
sed -i "/DB_USER/c\define('DB_USER', 'wpuser');" wp-config.php
sed -i "/DB_PASSWORD/c\define('DB_PASSWORD', '${db_password}');" wp-config.php
sed -i "/DB_HOST/c\define('DB_HOST', '${db_address}:${db_port}');" wp-config.php