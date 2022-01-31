#!/bin/sh

echo -e "\n Updating System .."
sudo apt-get update -y && sudo apt-get upgrade -y

echo -e "\n Installing Apache2"
sudo apt-get install apache2 -y

#echo -e "\n Verify install"

# Permissions
echo -e "\n Permissions for /var/www"
sudo chown -R www-data:www-data /var/www

echo -e "\n Enabling Modules "
sudo a2enmod rewrite

# Restart Apache
echo -e "\n Restarting Apache "
sudo service apache2 restart
