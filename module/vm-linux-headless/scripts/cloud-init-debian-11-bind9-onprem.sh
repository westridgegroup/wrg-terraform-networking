#!/bin/bash
############################
# Target:Debian 11         #
############################
sleep 20

user_name=adminuser

############################
# start cloud init         #
############################

sudo timedatectl set-timezone America/New_York
sudo touch /tmp/cloud-init.log
sudo chmod a+w /tmp/cloud-init.log
sudo sed "1i 127.0.0.1  $HOSTNAME" /etc/hosts
echo "cloud init start" >> /tmp/cloud-init.log
date >> /tmp/cloud-init.log
cd /home/$user_name
mkdir installs
mkdir repos
echo "complete: home setup" >> /tmp/cloud-init.log
sudo apt-get update -y 
sudo apt-get upgrade -y 
echo "complete: update & upgrade" >> /tmp/cloud-init.log
sudo apt-get install dnsutils -y
sudo apt-get install bind9 -y

sudo sed -i "15i    recursion yes;" /etc/bind/named.conf.options
sudo sed -i "15i    forwarders {" /etc/bind/named.conf.options
sudo sed -i "16i        8.8.8.8;" /etc/bind/named.conf.options
sudo sed -i "17i    };" /etc/bind/named.conf.options

sudo systemctl restart bind9

