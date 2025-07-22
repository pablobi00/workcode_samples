#!/bin/bash

# Upgrade Ubuntu

apt -y update
apt list --upgradable
apt -y full-upgrade
apt -y install ntp mlocate unzip links 
apt -y install default-jre

systemctl enable ntp
timedatectl set-timezone America/Vancouver

# apt install -y awscli
# curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# curl -fsSL https://get.docker.com -o get-docker.sh
# sh get-docker.sh

# optional - configure auto-shutdown
# echo "05 19 * * * sudo shutdown" >> /var/spool/cron/root
# chmod 600 /var/spool/cron/root

# files and processes minimums 

cp /etc/sysctl.conf /etc/sysctl.conf.ori
echo 'fs.file-max=65535' >> /etc/sysctl.conf
sysctl -p

cp  /etc/security/limits.conf  /etc/security/limits.conf.ori
sed -i '/# End of file/i \
*    soft    nproc    65535\
*    hard    nproc    65535\
*    soft    nofile    65535\
*    hard    nofile    65535'  /etc/security/limits.conf

# Fusion specific settings 

# groupadd hadoop
adduser hdfs

# usermod -aG hadoop hdfs
echo "hdfs ALL = (ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/hdfs
chmod 0440 /etc/sudoers.d/hdfs

# ip security

ufw disable

printf  "\n=====\n[EOL]\n"