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

touch temp.sql

echo "CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY '${db_password}';\n" > temp.sql
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';\n" >> temp.sql
echo "FLUSH PRIVILEGES;\n" >> temp.sql
echo "Exit;\n" >> temp.sql

mysql -p${db_password} -u root -h ${db_address} wordpress < temp.sql

rm temp.sql

cp wp-config-sample.php wp-config.php
sed -i "/DB_NAME/c\define('DB_NAME', 'wordpress');'" wp-config.php
sed -i "/DB_USER/c\define('DB_USER', 'wpuser');" wp-config.php
sed -i "/DB_PASSWORD/c\define('DB_PASSWORD', '${db_password}');" wp-config.php
sed -i "/DB_HOST/c\define('DB_HOST', '${db_address}:${db_port}');" wp-config.php
sed -i "/WP_DEBUG/c\define('WP_DEBUG', 'true');" wp-config.php
sed -i "/WP_DEBUG_LOG/c\define('WP_DEBUG_LOG', 'true');" wp-config.php

touch /etc/systemd/system/refreshLab.service
touch /etc/systemd/system/refreshLab.timer
touch /usr/local/bin/refreshLab.sh

echo '${refreshLabService}' > /etc/systemd/system/refreshLab.service
echo '${refreshLabTimer}' > /etc/systemd/system/refreshLab.timer
echo "${refreshLabScript}" > /usr/local/bin/refreshLab.sh

chmod 744 /usr/local/bin/refreshLab.sh

systemctl start refreshLab.timer
systemctl enable refreshLab.timer