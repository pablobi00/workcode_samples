#!/bin/bash

# Version 6.2022.02.08a
# CDH/P 5,6 & 7

printf '\e[0;36m\n===== [OS Tools and update] =============================\n\e[0m'

apt -y update
apt list --upgradable
apt -y full-upgrade

# yum -y update


printf "\e[31m\n===== [CDP/CDH] =============\n\e[0m"

sleep 5

# CM ====================================

# wget https://archive.cloudera.com/p/cm5/installer/5.1.6.1/cloudera-manager-installer.bin

# wget https://archive.cloudera.com/cm7/7.1.4/cloudera-manager-installer.bin

wget https://archive.cloudera.com/cm7/7.4.4/cloudera-manager-installer.bin

# wget https://<user_name:password>@archive.cloudera.com/cm5/installer/5.16.1/cloudera-manager-installer.bin

chmod u+x cloudera-manager-installer.bin
./cloudera-manager-installer.bin --username=<user_name>--password=<password>

# ./cloudera-manager-installer.bin

# CDP ====================================

wget https://<user_name:password>@archive.cloudera.com/p/cdh7/7.1.7/parcels/CDH-7.1.7-1.cdh7.1.7.p0.15945976-bionic.parcel
wget https://<user_name:password>@archive.cloudera.com/p/cdh7/7.1.7/parcels/CDH-7.1.7-1.cdh7.1.7.p0.15945976-bionic.parcel.sha1

mv CDH-7.1.7-1.cdh7.1.7.p0.15945976-bionic.parcel.sha1 CDH-7.1.7-1.cdh7.1.7.p0.15945976-bionic.parcel.sha
cp CDH-7* /opt/cloudera/parcel-repo

chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-


# CDH ====================================

# CDH 6 ============

# wget https://<user_name:password>@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel
# wget https://<user_name:password>@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha1
# mv CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha1 CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha
# cp CDH-6* /opt/cloudera/parcel-repo
# chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-6*

# CDH 5 ============

# wget https://<user_name:password>@archive.cloudera.com/p/cdh5/parcels/5.14.4/CDH-5.14.4-1.cdh5.14.4.p0.3-el7.parcel
# wget https://<user_name:password>@archive.cloudera.com/p/cdh5/parcels/5.14.4/CDH-5.14.4-1.cdh5.14.4.p0.3-el7.parcel.sha1


# mv CDH-5.14.4-1.cdh5.14.4.p0.3-el7.parcel.sha1 CDH-5.14.4-1.cdh5.14.4.p0.3-el7.parcel.sha

# cp CDH-5* /opt/cloudera/parcel-repo
# chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-5*


# wget https://<user_name:password>@archive.cloudera.com/p/cdh5/parcels/5.14.2/CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel
# wget https://<user_name:password>@archive.cloudera.com/p/cdh5/parcels/5.14.2/CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel.sha1

# wget https://<user_name:password>@archive.cloudera.com/p/cdh5/parcels/5.14.2/CDH-5.14.2-1.cdh5.14.2.p0.3-xenial.parcel
# wget https://<user_name:password>@archive.cloudera.com/p/cdh5/parcels/5.14.2/CDH-5.14.2-1.cdh5.14.2.p0.3-xenial.parcel.sha1

# CDH 5 ==========

# mv CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel.sha1 CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel.sha
# mv CDH-5.14.2-1.cdh5.14.2.p0.3-xenial.parcel.sha1 CDH-5.14.2-1.cdh5.14.2.p0.3-xenial.parcel.sha
# cp CDH-5* /opt/cloudera/parcel-repo
# chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-5*



# sed -i 's/vm.swappiness=1/vm.swappiness=10/g' /etc/sysctl.conf
# echo "vm.swappiness=10" >> /etc/sysctl.conf
# sysctl -p

# For azure - Ubuntu --- Allow azureuser sudo without password

# chmod o+w /etc/sudoers
# echo "azureuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# chmod o-w /etc/sudoers

# ==============================================================================

printf "\e[0;36m\n===== [EOF] =======\n\e[0m\n\n"