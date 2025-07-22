#!/bin/bash

# Version 5.2021.10.05
# CDH 5 localrepo

printf '\e[0;36m\n===== [OS Tools and update] =============================\n\e[0m'

# apt -y update
# apt list --upgradable
# apt -y full-upgrade

yum -y update


printf "\e[31m\n===== [CDP/CDH] =============\n\e[0m"

sleep 5

# CM ====================================

wget https://<user_name>:<password>@archive.cloudera.com/cm5/installer/5.16.1/cloudera-manager-installer.bin

chmod u+x cloudera-manager-installer.bin
./cloudera-manager-installer.bin --username=<user_name>--password=<password>

# CDH 5 Local Repo ============

echo "[cloudera-manager]
name = Cloudera Manager, Version 5.16.2.4505
baseurl = http://10.138.0.20/cm5/centos/cloudera-manager
gpgcheck = 0" > /etc/yum.repos.d/cloudera-manager.repo1

echo "[cloudera-cdh5]
name = Cloudera CDH, Version CUSTOM
baseurl = http://10.138.0.20/cdh5/centos/cloudera-cdh5/
gpgcheck = 0

[cloudera-cdh5.14]
name = Cloudera CDH, Version 5.14
baseurl = http://10.138.0.20/cdh5/centos/cloudera-cdh5.14.4/cdh/5.14.4
gpgcheck = 0" > /etc/yum.repos.d/cloudera-cdh5.repo


# ==============================================================================

printf "\e[0;36m\n===== [EOF] =======\n\e[0m\n\n"