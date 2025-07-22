#!/bin/bash

# prepubuntu.sh v3.0a 2021.02.12
# Added Java variables update and CDP

# Upgrade Ubuntu

printf '\e[31m\n===== [OS Tools and upgdate] =====\n\e[0m'

apt -y update
apt list --upgradable
apt -y full-upgrade
apt -y install mlocate unzip nmon 

sleep 5

# Configure Timezone

timedatectl set-ntp true && timedatectl set-timezone America/Vancouver

printf "\e[31m\n===== [Java] =============\n\e[0m"

apt install -y openjdk-8-jre

# add to root profile

echo "export JAVA_HOME=$(alternatives --display java | grep "slave jre:" | awk '{print $3}')" >> ~/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bashrc

# add to current session 

export "JAVA_HOME=$(alternatives --display java | grep "slave jre:" | awk '{print $3}')"
export PATH=$PATH:$JAVA_HOME/bin

echo $JAVA_HOME
echo $PATH

sleep 10

printf "\e[31m\n===== [Optional Tools] =============\n\e[0m"

# Configure auto-shutdown

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "00 19 * * * sudo shutdown" >> mycron
#install new cron file
crontab mycron
rm mycron

# files and processes minimums

cp /etc/security/limits.conf /etc/security/limits.conf.ori
sed -i '/# End of file/i \
*    soft    nproc    65535\
*    hard    nproc    65535\
*    soft    nofile    655350\
*    hard    nofile    655350' /etc/security/limits.conf

# Memory and Network Optimization

cp /etc/sysctl.conf /etc/sysctl.conf.ori

# FUSION specific settings

printf '\e[31m\n===== [Fusion - standalone] =====\n\e[0m'

# groupadd hadoop
# adduser hdfs
# usermod -aG hadoop hdfs
# echo "hdfs ALL = (ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/hdfs
# chmod 0440 /etc/sudoers.d/hdfs

# printf '\e[31m\n===== [Firewall] =====\n\e[0m'

# Disable Linux Firewall - will be enabled back afterwards

ufw disable

# SElinux - if installed -----> execute # sestatus
# setenforce 0
# sed -i 's/enabled/disabled/g' /etc/selinux/config

# OPTIONAL TOOLS

printf '\e[31m\n===== [Tools] =====\n\n\e[0m'

printf '\e[31m\n===== [AWS, Azure, Docker] =====\n\e[0m'

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

printf '\e[31m\n===== [Cloudera] =====\n\e[0m'

# wget https://archive.cloudera.com/cm7/7.1.4/cloudera-manager-installer.bin
# chmod u+x cloudera-manager-installer.bin
# ./cloudera-manager-installer.bin

# cd /opt/cloudera/parcel-repo
# wget https://archive.cloudera.com/cdh7/7.1.4.0/parcels/CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel
# wget https://archive.cloudera.com/cdh7/7.1.4.0/parcels/CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha1
# mv CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha1 CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha
# chown cloudera-scm:cloudera-scm CDH-7.1.4-1*


printf '\e[31m\n===== [DBs] =====\n\e[0m'

zypper install -y postgresql-jdbc
zypper install -y mysql-connector-java*
apt install -y mysql-server
mysql_secure_installation
systemctl status mysql.service
mysql -u root -p

printf "\e[31m\n=====\n[EOL]\n\e[0m\n\n"