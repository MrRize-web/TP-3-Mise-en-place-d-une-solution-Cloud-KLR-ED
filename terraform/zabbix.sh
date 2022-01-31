#!/bin/sh
echo "Updating ..."
sudo apt update && sudo apt upgrade -y

echo "Installing APACHE2 ..."
sudo apt install apache2 php php-mysql php-mysqlnd php-ldap php-bcmath php-mbstring php-gd php-pdo php-xml libapache2-mod-php

echo "Enabling APACHE2"
sudo systemctl enable apache2

echo "Restaring APACHE2"
sudo systemctl restart apache2

echo "Installing MARIADB ..."
sudo apt install mariadb-server mariadb-client

echo "Configuration of database mysql ..."
sudo mysql -e "drop database if exists zabbix;"
sudo mysql -e "create database if not exists zabbix character set utf8 collate utf8_bin;"
sudo mysql -e "create user if not exists 'zabbix'@'localhost' identified by 'Epsi'"
sudo mysql -e "grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by 'Epsi'"

sudo touch ~/.my.cnf

sudo sed -i '1i[mysql]' ~/.my.cnf
sudo sed -i '2iuser = zabbix' ~/.my.cnf
sudo sed -i '3ipassword = Epsi' ~/.my.cnf

sudo chmod 760 ~/.my.cnf

echo "Get Zabbix Repo 5.4-1 debian11"
sudo wget --no-check-certificate https://repo.zabbix.com/zabbix/5.4/debian/pool/main/z/zabbix-release/zabbix-release_5.4-1+debian11_all.deb

echo "DPKG Zabbix repo"
sudo dpkg -i zabbix-release_5.4-1+debian11_all.deb

echo "Updating..."
sudo apt update -y

echo "Installing Zabbix ..."
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y

echo "Installing Zabbix Database ..."
sudo zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | sudo mysql -uzabbix -p zabbix --password=Epsi

echo "Configuration of zabbix server files ..."
sudo sed -i '/# DB=Host/c\DBHOST=localhost' /etc/zabbix/zabbix_server.conf
sudo sed -i '/DBName=/c\DBName=zabbix' /etc/zabbix/zabbix_server.conf
sudo sed -i '/DBUser=/c\DBUser=zabbix' /etc/zabbix/zabbix_server.conf
sudo sed -i '/DBPassword=/c\DBPassword=Epsi' /etc/zabbix/zabbix_server.conf

# php_value date.timezone Europe/Riga
echo "Editing Timezone for Europe/Riga ..."
sudo sed -i 's/# php_value date.timezone Europe/Riga/php_value date.timezone Europe/Riga/' /etc/zabbix/apache.conf

echo "Restarting and Enabling Services ..."
sudo systemctl restart apache2

sudo systemctl start zabbix-server zabbix-agent

sudo systemctl enable zabbix-server zabbix-agent

sudo systemctl status zabbix-server

sudo systemctl status zabbix-agent

sudo ufw allow 80/tcp

sudo ufw allow 443/tcp

sudo ufw reload
