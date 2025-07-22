#!/bin/bash

# cdh-deploy.sh v3.0 2021.07.09
# Generic - manual configuration 
# Upgrade OS

printf '\e[0;36m\n===== [OS Tools and update] =============================\n\e[0m'

apt -y update
apt list --upgradable
apt -y full-upgrade

# yum update -y

printf "\e[31m\n===== [CDP/CDH] =============\n\e[0m"

sleep 5

# Ambari repositories

# ------------------------- [CM] ----------------------------------------------------------

wget https://<user_name>:<password>@archive.cloudera.com/cm7/7.1.4/cloudera-manager-installer.bin
chmod u+x cloudera-manager-installer.bin
./cloudera-manager-installer.bin

# ------------------------- [CDP] ----------------------------------------------------------

# ---- Ubuntu 18 - BIONIC

# wget https://<user_name>:<password>@archive.cloudera.com/p/cdh7/7.1.6.0/parcels/CDH-7.1.6-1.cdh7.1.6.p0.10506313-bionic.parcel
# wget https://<user_name>:<password>@archive.cloudera.com/p/cdh7/7.1.6.0/parcels/CDH-7.1.6-1.cdh7.1.6.p0.10506313-bionic.parcel.sha1

# mv CDH-7.1.6-1.cdh7.1.6.p0.10506313-bionic.parcel.sha1 CDH-7.1.6-1.cdh7.1.6.p0.10506313-bionic.parcel.sha

# cp CDH* /opt/cloudera/parcel-repo
# chown cloudera-scm:cloudera-scm  /opt/cloudera/parcel-repo/CDH-7.*

# ---------------------------- [CDH] ----------------------------------------------------------

# ------------------------- [CDH 6.3.4] ----------------------------------------------------------

# ---- CentOS

# wget https://<user_name>:<password>@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel
# wget https://<user_name>:<password>@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha1
# mv CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha1 CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha

# ----- Ubuntu Bionic

wget https://<user_name>:<password>@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-bionic.parcel
wget https://<user_name>:<password>@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-bionic.parcel.sha1
mv CDH-6.3.4-1.cdh6.3.4.p0.6626826-bionic.parcel.sha1 CDH-6.3.4-1.cdh6.3.4.p0.6626826-bionic.parcel.sha

# ------ Common

cp CDH-6* /opt/cloudera/parcel-repo
chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-6*


# ------------------------- [CDH 5.14.2] ----------------------------------------------------------

# -------- CentOS

# wget https://<user_name>:<password>@archive.cloudera.com/p/cdh5/parcels/5.14.2/CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel
# wget https://<user_name>:<password>@archive.cloudera.com/p/cdh5/parcels/5.14.2/CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel.sha1

# --------- Ubuntu Xenial

# wget https://<user_name>:<password>@archive.cloudera.com/p/cdh5/parcels/5.14.2/CDH-5.14.2-1.cdh5.14.2.p0.3-xenial.parcel
# wget https://<user_name>:<password>@archive.cloudera.com/p/cdh5/parcels/5.14.2/CDH-5.14.2-1.cdh5.14.2.p0.3-xenial.parcel.sha1


# mv CDH-5.14.2-1.cdh5.14.2.p0.3-xenial.parcel.sha1 CDH-5.14.2-1.cdh5.14.2.p0.3-xenial.parcel.sha
# cp CDH-5* /opt/cloudera/parcel-repo
# chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-5*

# ===================================================================

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled

apt install -y rpcbind
rpcbind

# sed -i 's/vm.swappiness=1/vm.swappiness=10/g' /etc/sysctl.conf
echo "vm.swappiness=10" >> /etc/sysctl.conf
sysctl -p

printf "\e[0;36m\n===== [EOF] =======\n\e[0m\n\n"