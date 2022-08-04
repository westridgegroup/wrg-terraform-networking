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