#!/bin/bash

# Version 2020.11.03

yum update -y
yum install unzip -y

dnf --enablerepo=PowerTools install elinks

timedatectl set-ntp true
timedatectl set-timezone America/Vancouver

# disable SELINUX and Firewall

setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl disable firewalld
sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers

# configure auto-shutdown

echo "05 19 * * * sudo shutdown" >> /var/spool/cron/root
chmod 600 /var/spool/cron/root

# files and processes minimus 

cp /etc/sysctl.conf /etc/sysctl.conf.ori
echo 'fs.file-max=65535' >> /etc/sysctl.conf
sysctl -p

cp  /etc/security/limits.conf  /etc/security/limits.conf.ori

sed -i '/# End of file/i \
*    soft    nproc    65535\
*    hard    nproc    65535\
*    soft    nofile    65535\
*    hard    nofile    65535'  /etc/security/limits.conf

cp /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc.conf.ori
sed -i s'/4096/65535'/g /etc/security/limits.d/20-nproc.conf

# groupadd hadoop
# adduser -m hdfs

# usermod -aG hadoop hdfs
# echo "hdfs ALL = (ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/hdfs
# chmod 0440 /etc/sudoers.d/hdfs


# Azure

rpm --import https://packages.microsoft.com/keys/microsoft.asc

sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

yum install azure-cli -y

# AWS

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

printf  "\n=====\n[EOL]\n"