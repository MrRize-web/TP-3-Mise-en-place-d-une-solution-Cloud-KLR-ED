#!/bin/sh


#We didnt found a way to use the IP ADRESSES that terraform assign to the instances, so you'll need to change [IP] and [IP2] by their respective IP ADRESSES
echo "Updating ..."
sudo apt update && sudo apt upgrade -y

echo "Installing APACHE2 ..."
sudo apt install apache2 -y

echo "Enabling APACHE2"
sudo systemctl enable apache2

echo "Restaring APACHE2"
sudo systemctl restart apache2

echo "Installing HAPROXY"
sudo apt install haproxy -y

echo "Configuring haproxy.cfg ..."
sudo sed -i '$a#Define frontend' /etc/haproxy/haproxy.cfg

sudo sed -i '$afrontend apache_front' /etc/haproxy/haproxy.cfg
sudo sed -i '$a        bind *:80' /etc/haproxy/haproxy.cfg
sudo sed -i '$a        default_backend    apache_backend_servers' /etc/haproxy/haproxy.cfg
sudo sed -i '$a        option             forwardfor' /etc/haproxy/haproxy.cfg

sudo sed -i '$a#Define backend' /etc/haproxy/haproxy.cfg

sudo sed -i '$abackend apache_backend_servers' /etc/haproxy/haproxy.cfg
sudo sed -i '$a        balance            roundrobin' /etc/haproxy/haproxy.cfg
sudo sed -i '$a        server             backend01 [IP] check' /etc/haproxy/haproxy.cfg
sudo sed -i '$a        server             backend02 [IP] check' /etc/haproxy/haproxy.cfg

echo "Restarting HAPROXY ..."
sudo systemctl restart haproxy



















































