#!/bin/bash

# prepubuntu.sh v7.0 2022.02.09a
# Added Oracle JDK via Azure Blob

# CONFIRM USER NAME AND HOME DIRECTORY

USERNOWHOME='<home>'
USERNOWNAME='<user>

# Upgrade Ubuntu

printf '\e[0;36m\n===== [OS Tools and update] =============================\n\e[0m'

apt -y update
apt list --upgradable
apt -y full-upgrade

apt -y install mlocate unzip nmon python3-pip iftop bmon cbm vnstat
apt -y ntp

sleep 5

# Configure Timezone

systemctl enable ntpd
systemctl start ntpd

timedatectl set-ntp true && timedatectl set-timezone America/Vancouver

printf "\e[0;36m\n===== [Java] ===========================================\n\e[0m"


printf "\e[31m\n===== [Open JDK] =============\n\e[0m"


apt install -y openjdk-8-jre-headless

printf "\e[31m\n===== [Oracle Java] =============\n\e[0m"

# wget https://<storage_account>.blob.core.windows.net/transfer001/jdk-8u291-linux-x64.tar.gz
# mkdir -p /usr/lib/jvm
# tar zxvf jdk-8u291-linux-x64.tar.gz -C /usr/lib/jvm

# export JAVA01=jdk1.8.0_291
# update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/$JAVA01/bin/java" 1
# update-alternatives --set java /usr/lib/jvm/$JAVA01/bin/java

# add to root profile

echo "export JAVA_HOME=$(update-alternatives --list java | awk -F'/bin/java' '{print $1}')" >> ~/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bashrc

source ~/.bashrc

printf "\e[1;32m\n===== [Java Verification] ===========================================\n\e[0m"

echo $JAVA_HOME
echo $PATH
update-alternatives --list java
java -version

sleep 10

printf "\e[0;36m\n===== [ OS Parameters/Configuration ] ===========================\n\e[0m"

# Configure auto-shutdown

#write out current crontab
crontab -l > mycron

#echo new cron into cron file
echo "10 19 * * * sudo shutdown 0" >> mycron

#install new cron file
crontab mycron
rm mycron

# files and processes minimums

cp /etc/security/limits.conf /etc/security/limits.conf.ori
printf '\n*    soft    nproc    65535\n*    hard    nproc    65535\n*    soft    nofile   655350\n*    hard    nofile   655350\n' >> /etc/security/limits.conf

printf '\e[0;36m\n===== [Firewall] =========================\n\e[0m'

# Disable Linux Firewall - will be enabled back afterwards

ufw disable

# SElinux - if installed -----> execute # sestatus

setenforce 0
sed -i 's/enabled/disabled/g' /etc/selinux/config

# OPTIONAL TOOLS

printf '\e[0;36m\n===== [Tools] ======================\n\n\e[0m'

printf '\e[0;36m\n===== [AWS, Azure] =====\n\e[0m'

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

printf '\e[0;36m\n===== [Docker] =====\n\e[0m'

# ======= Docker Repositories ==============

# apt-get -y install \
	# apt-transport-https \
	# ca-certificates \
	# curl \
	# gnupg-agent \
	# software-properties-common

# Docker GPA KEY

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# ========== Setup repository ===============================

# add-apt-repository \
	# "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	# $(lsb_release -cs) \
	# stable"

# Intalll Docker engine ==================================

# apt-get update -y
# apt-get install -y docker-ce docker-ce-cli containerd.io

# ====== Compose ===========================================

# curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose


# ==========================================================================================

# printf '\e[0;36m\n===== [DBs] ============\n\e[0m'

# apt install -y mysql-server

# ======= use all dfaults
# mysql_secure_installation

# systemctl status mysql.service
# mysql -u root -p
# ======= test ---->  SELECT user,authentication_string,plugin,host FROM mysql.user;

printf '\e[0;36m\n===== [Other] ============\n\e[0m'

printf "\e[31m\n===== [Networking] =============\n\e[0m"

# disable IPv6

cat >> /etc/sysctl.conf <<EOL
net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1
EOL

# Passwordless sudo

printf "%s ALL=(ALL) NOPASSWD:ALL\n" $USERNOWNAME >> /etc/sudoers

printf "\e[0;36m\n===== [EOF] =======\n\e[0m\n\n"