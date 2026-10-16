#!/bin/bash

# prepubuntuCDPv1.sh v1.0 2021.01.13

# Upgrade Ubuntu

printf '\e[31m\n===== [OS Tools and upgdate] =====\n\e[0m'

apt -y update
apt list --upgradable
apt -y full-upgrade
apt -y install mlocate unzip nmon

sleep 5

mkdir installers
cd installers

# Configure Timezone

systemctl enable ntp
timedatectl set-ntp true
timedatectl set-timezone America/Vancouver

# Configure auto-shutdown

#write out current crontab

crontab -l > mycron
#echo new cron into cron file
echo "10 19 * * * sudo shutdown" >> mycron
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

# Network Optimization

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
net.core.default_qdisc = fq\
vm.swappiness=10' /etc/sysctl.conf

sysctl -p

/sbin/ifconfig eth0 txqueuelen 10000
ethtool -G eth0 rx 18811 tx 2560
sysctl -w net.core.dev_weight=64

printf '\e[31m\n===== [Firewall] =====\n\e[0m'

# Disable Linux Firewall - will be enabled back afterwards

ufw disable

# SElinux - if installed -----> execute # sestatus
setenforce 0
sed -i 's/enabled/disabled/g' /etc/selinux/config

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

wget https://archive.cloudera.com/cm7/7.1.4/cloudera-manager-installer.bin
chmod u+x cloudera-manager-installer.bin
./cloudera-manager-installer.bin

cd /opt/cloudera/parcel-repo
wget https://archive.cloudera.com/cdh7/7.1.4.0/parcels/CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel
wget https://archive.cloudera.com/cdh7/7.1.4.0/parcels/CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha1
mv CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha1 CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha
chown cloudera-scm:cloudera-scm CDH-7.1.4-1*

printf "\e[31m\n=====\n[EOL]\n\e[0m\n\n"