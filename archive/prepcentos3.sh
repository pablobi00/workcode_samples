#!/bin/bash

# prepcentos.sh v3.0 2020.12.03

# Upgrade Ubuntu

yum -y update
yum -y install ntp mlocate unzip links nmon wget zypper gettext unix2dos
sleep 5

# Configure Timezone

systemctl enable ntp
timedatectl set-ntp true
timedatectl set-timezone America/Vancouver

# java

yum install -y java-1.8.0-openjdk

# OPTIONAL TOOLS

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Configure auto-shutdown

# write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "00 19 * * * sudo shutdown  0" >> mycron
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

sed -i '$ a fs.file-max=655350\
net.ipv4.tcp_keepalive_intvl=15\
net.ipv4.tcp_keepalive_probes=5\
net.ipv4.tcp_mem = 1543344      2057794 6086688\
net.core.wmem_max = 16777216\
net.core.rmem_max = 16777216\
net.core.wmem_default = 4194304\
net.core.rmem_default = 4194304\
net.core.netdev_max_backlog = 4096\
net.ipv4.tcp_wmem = 4096 16384 16777216\
net.ipv4.tcp_rmem = 4096 87380 16777216\
net.ipv4.tcp_max_syn_backlog = 2048\
net.core.netdev_budget = 1200\
net.core.netdev_budget_usecs = 20000\
net.core.somaxconn = 1024\
net.ipv4.tcp_slow_start_after_idle = 0\
net.core.default_qdisc = fq' /etc/sysctl.conf

sysctl -p

/sbin/ifconfig eth0 txqueuelen 10000
ethtool -G eth0 rx 18811 tx 2560
sysctl -w net.core.dev_weight=64

# FUSION specific settings

groupadd hadoop
adduser hdfs
usermod -aG hadoop hdfs
echo "hdfs ALL = (ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/hdfs
chmod 0440 /etc/sudoers.d/hdfs

# Disable Linux Firewall - will be enabled back afterwards

systemctl stop firewalld
systemctl disable firewalld

# SElinux - if installed ___> check # sestatus

setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config

printf "\e[31m\n===== [HDP] =============\n\e[0m"

sleep 5

# Ambari repositories

# sleep 5

printf '\e[31m\n===== [DBs] =====\n\e[0m'

# zypper install -y postgresql-jdbc
# zypper install -y mysql-connector-java*
# apt install -y mysql-server
# mysql_secure_installation
# systemctl status mysql.service

printf "\e[31m\n=====\n[EOL]\n\e[0m\n"