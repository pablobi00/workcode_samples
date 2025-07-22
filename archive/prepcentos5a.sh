#!/bin/bash

# prepcentos5.sh v4.1 2021.06.09
# Added CDP

# Upgrade OS

yum -y update
yum -y install ntp mlocate unzip wget
# yum -y install gettext unix2dos wget iftop

sleep 5

# Configure Timezone

timedatectl set-ntp true && timedatectl set-timezone America/Vancouver

printf "\e[31m\n===== [Java] =============\n\e[0m"

wget https://<storage_account>.blob.core.windows.net/transfer001/jre-8u301-linux-x64.rpm
yum install -y ./jre-8u301-linux-x64.rpm
java -version

sleep 20

printf "\e[31m\n===== [Optional Tools] =============\n\e[0m"

# =============== [CLI] =================

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# =========== [Configure auto-shutdown] ========================

# write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "00 20 * * * sudo shutdown  0" >> mycron
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

# Optimizations

cp /etc/sysctl.conf /etc/sysctl.conf.ori

sed -i '$ a vm.swappiness=10' /etc/sysctl.conf

sysctl -p

# Disable Linux Firewall - will be enabled back afterwards

systemctl stop firewalld
systemctl disable firewalld

# SElinux - if installed ___> check # sestatus

setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config

printf "\e[31m\n=====\n[EOL]\n\e[0m\n"