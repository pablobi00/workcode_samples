

#!/bin/bash

# prepubuntu.sh v2.0

# Upgrade Ubuntu
 
apt -y update
apt list --upgradable
apt -y full-upgrade
apt -y install ntp mlocate unzip links nmon
systemctl enable ntp
timedatectl set-timezone America/Vancouver
 
# java
 
apt -y install default-jre
 
 
# OPTIONAL TOOLS
# apt install -y awscli
# curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# curl -fsSL https://get.docker.com -o get-docker.sh
# sh get-docker.sh
 
# optional - configure auto-shutdown
# echo "05 19 * * * sudo shutdown" >> /var/spool/cron/root
# chmod 600 /var/spool/cron/root
 
# files and processes minimums
 
sysctl -p
 
cp  /etc/security/limits.conf  /etc/security/limits.conf.ori
sed -i '/# End of file/i \
*    soft    nproc    65535\
*    hard    nproc    65535\
*    soft    nofile    655350\
*    hard    nofile    655350'  /etc/security/limits.conf
 
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
 
# groupadd hadoop
adduser hdfs
# usermod -aG hadoop hdfs
echo "hdfs ALL = (ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/hdfs
chmod 0440 /etc/sudoers.d/hdfs
 
# Disable Linux Firewall - will be enabled back afterwards
ufw disable
 
printf  "\n=====\n[EOL]\n"
