#!/bin/bash

# prepcentos6.sh 2021.09.07

# COnfirm user name and home

# USERNOWHOME='<home>'
USERNOWNAME='azureuser'

# USERNOWHOME=$1
# USERNOWNAME=$2

# Upgrade OS

yum -y update
yum -y install ntp mlocate unzip wget tmux iftop vim
# yum -y install gettext unix2dos

sleep 5

# Configure Timezone

systemctl enable ntpd
systemctl start ntpd

timedatectl set-ntp true && timedatectl set-timezone America/Vancouver

printf "\e[31m\n===== [Oracle Java] =============\n\e[0m"

wget https://<storage_account>.blob.core.windows.net/transfer001/jdk-8u301-linux-x64.rpm
yum install -y ./jdk-8u301-linux-x64.rpm

# sudo alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_291/bin/java 200000

# export "PATH=$PATH:/usr/java/latest/bin"
# set JAVA_HOME=/usr/java/latest

# echo "export PATH="$PATH:/usr/java/latest/bin"" >> ~/.bashrc 
# echo "set JAVA_HOME=/usr/java/latest" >> ~/.bashrc

printf '\e[1;31m\n===== [Java check ] =====\n\e[0m'

# echo $JAVA_HOME
# echo $PATH
# java -version

printf "\e[31m\n===== [Open JDK] =============\n\e[0m"

# yum install -y java-1.8.0-openjdk
# add to root profile
# echo "export JAVA_HOME=$(alternatives --display java | grep "slave jre:" | awk '{print $3}')" >> ~/.bashrc
# echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bashrc
# add to current session
# export "JAVA_HOME=$(alternatives --display java | grep "slave jre:" | awk '{print $3}')"
# export PATH=$PATH:$JAVA_HOME/bin
# echo $JAVA_HOME
# echo $PATH

sleep 20

printf "\e[31m\n===== [Optional Tools] =============\n\e[0m"


# =============== [CLI] =================

# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# ./aws/install

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# =============== [Docker] =================

# curl -fsSL https://get.docker.com -o get-docker.sh
# sh get-docker.sh

# https://docs.docker.com/compose/install/#install-compose

# curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose

# =========== [Configure auto-shutdown] ========================

# write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "05 20 * * * sudo shutdown  0" >> mycron
#install new cron file
crontab mycron
rm mycron

# files and processes minimums

cp /etc/security/limits.conf /etc/security/limits.conf.ori
printf '\n*    soft    nproc    65535\n*    hard    nproc    65535\n*    soft    nofile   65535\n*    hard    nofile   65535\n' >> /etc/security/limits.conf

# Optimizations


printf "\e[31m\n===== [Networking] =============\n\e[0m"

# disable IPv6

cat >> /etc/sysctl.conf <<EOL
net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1
EOL

sudo sysctl -p

printf "\e[31m\n===== [Hadoop and Fusion settings] =============\n\e[0m"


# NFS gateway in Hadoop

cp /etc/sysctl.conf /etc/sysctl.conf.ori

sed -i '$ a vm.swappiness=10' /etc/sysctl.conf

sysctl -p

# CDH

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled

yum install -y rpcbind
rpcbind

cp /etc/sysctl.conf /etc/sysctl.conf.ori
sed -i '$ a vm.swappiness=10' /etc/sysctl.conf
sysctl -p


# FUSION specific settings - standalone node 

# groupadd hadoop
# adduser hdfs
# usermod -aG hadoop hdfs
# echo "hdfs ALL = (ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/hdfs
# chmod 0440 /etc/sudoers.d/hdfs

printf "\e[31m\n===== [Security] =============\n\e[0m"

# Disable Linux Firewall - will be enabled back afterwards

systemctl stop firewalld
systemctl disable firewalld

# SElinux - if installed ___> check # sestatus

setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config

# Configure SSH Password less logins

# cd $USERNOWHOME
# touch $USERNOWHOME/.ssh/config

# printf "Host * \nStrictHostKeyChecking no \nUserKnownHostsFile=/dev/null" > $USERNOWHOME/.ssh/config

# cd .ssh
#chmod 400 config
# echo -e  'y\n'| ssh-keygen -t rsa -P "" -f $USERNOWHOME/.ssh/id_rsa

# cat $USERNOWHOME/.ssh/id_rsa.pub >> $USERNOWHOME/.ssh/authorized_keys

# systemctl enable sshd.service
# systemctl restart sshd.service

printf "%s ALL=(ALL) NOPASSWD:ALL\n" $USERNOWNAME >> /etc/sudoers

printf '\e[31m\n===== [DBs] =====\n\e[0m'

# apt install -y mysql-server
# mysql_secure_installation
# systemctl status mysql.service

printf "\e[31m\n=====\n[EOL]\n\e[0m\n"