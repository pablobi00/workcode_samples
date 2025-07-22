#!/bin/bash

# prepcentos41.sh v4.1 2021.02.10
# Added CDP

# Upgrade OS

yum -y update
yum -y install ntp mlocate unzip gettext unix2dos wget

sleep 5

# Configure Timezone

systemctl enable ntpd
systemctl start ntpd

timedatectl set-ntp true && timedatectl set-timezone America/Vancouver


printf "\e[31m\n===== [Java] =============\n\e[0m"


yum install -y java-1.8.0-openjdk

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

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# https://docs.docker.com/compose/install/#install-compose

curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

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
printf '\n*    soft    nproc    65535\n*    hard    nproc    65535\n*    soft    nofile   655350\n*    hard    nofile   655350\n' >> /etc/security/limits.conf

# Optimizations

cp /etc/sysctl.conf /etc/sysctl.conf.ori
sed -i '$ a vm.swappiness=10' /etc/sysctl.conf

sysctl -p

printf "\e[31m\n===== [Networking] =============\n\e[0m"

# disable IPv6

cat >> /etc/sysctl.conf <<EOL
net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1
EOL

sudo sysctl -p

# rpcbinf - NFS gateway in Hadoop

rpcbind

printf "\e[31m\n===== [Security] =============\n\e[0m"


# Disable Linux Firewall - will be enabled back afterwards

systemctl stop firewalld
systemctl disable firewalld

# SElinux - if installed ___> check # sestatus

setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config

# Configure SSH Password less logins -----> CHECK USER NAME

USERNOW='/home/azureuser'
USERNOWNAME='azureuser'

cd $USERNOW
touch $USERNOW/.ssh/config; echo "Host *\n StrictHostKeyChecking no\n  UserKnownHostsFile=/dev/null" > $USERNOW/.ssh/config 
cd .ssh
chmod 400 config

echo -e  'y\n'| ssh-keygen -t rsa -P "" -f $USERNOW/.ssh/id_rsa
cat '$USERNOW/.ssh/id_rsa.pub' >> '$USERNOW/.ssh/authorized_keys'

service sshd restart

systemctl enable sshd.service
systemctl restart sshd.service

echo '$USERNOWNAME ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# transparent huge pages

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled

sed -i '/exit 0/d' /etc/rc.local
source /etc/rc.local

# sleep 5

printf '\e[31m\n===== [DBs] =====\n\e[0m'

# apt install -y mysql-server
# mysql_secure_installation
# systemctl status mysql.service

printf "\e[31m\n=====\n[EOL]\n\e[0m\n"