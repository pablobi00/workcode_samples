#!/bin/bash

# Version 7.2022.02.14a
# CDH/P 5,6 & 7

printf '\e[0;36m\n===== [OS Tools and update] =============================\n\e[0m'

# apt -y update && apt list --upgradable && apt -y full-upgrade

# yum -y update


printf "\e[31m\n===== [CDP/CDH] =============\n\e[0m"

sleep 5

LICENSEU='<user>'
LICENSEP='<password>'

# CM ====================================

# wget https://archive.cloudera.com/p/cm5/installer/5.1.6.1/cloudera-manager-installer.bin
wget https://archive.cloudera.com/cm7/7.1.4/cloudera-manager-installer.bin

# wget https://archive.cloudera.com/cm7/7.4.4/cloudera-manager-installer.bin

# wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/cm5/installer/5.16.1/cloudera-manager-installer.bin

chmod u+x cloudera-manager-installer.bin
./cloudera-manager-installer.bin --username=$LICENSEU --password=$LICENSEP

# ==================================== CDP =========================================================================================================

# UBUNTU Bionic ---------------------------------------

# wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/p/cdh7/7.1.7.78/parcels/CDH-7.1.7-1.cdh7.1.7.p78.21656418-bionic.parcel
# wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/p/cdh7/7.1.7.78/parcels/CDH-7.1.7-1.cdh7.1.7.p78.21656418-bionic.parcel.sha1
# mv CDH-7.1.7-1.cdh7.1.7.p78.21656418-bionic.parcel.sha1 CDH-7.1.7-1.cdh7.1.7.p78.21656418-bionic.parcel.sha

# RHEL/CENTOS 7 ------------------------------------------

wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/p/cdh7/7.1.7.78/parcels/CDH-7.1.7-1.cdh7.1.7.p78.21656418-el7.parcel
wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/p/cdh7/7.1.7.78/parcels/CDH-7.1.7-1.cdh7.1.7.p78.21656418-el7.parcel.sha1

mv CDH-7.1.7-1.cdh7.1.7.p78.21656418-el7.parcel.sha1 CDH-7.1.7-1.cdh7.1.7.p78.21656418-el7.parcel.sha 

# -------------------------------------------------------------------------------------------

cp CDH-7* /opt/cloudera/parcel-repo
chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-7*


# ==================================== CDH =======================================================================================================

# CDH 6 ============

# wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel
#wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha1

# mv CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha1 CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha
# cp CDH-6* /opt/cloudera/parcel-repo
# chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-6*

# CDH 5 ============

# wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/p/cdh5/parcels/5.16.1/CDH-5.16.1-1.cdh5.16.1.p0.3-el7.parcel
# wget https://$LICENSEU:$LICENSEP@archive.cloudera.com/p/cdh5/parcels/5.16.1/CDH-5.16.1-1.cdh5.16.1.p0.3-el7.parcel.sha1


# mv CDH-5.16.1-1.cdh5.16.1.p0.3-el7.parcel.sha1 CDH-5.16.1-1.cdh5.16.1.p0.3-el7.parcel.sha 

# cp CDH-5* /opt/cloudera/parcel-repo
# chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/CDH-5*

# ======================================================================================

# CDH/CDP


echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled

# yum install -y rpcbind
apt install -y rpcbind
rpcbind

cp /etc/sysctl.conf /etc/sysctl.conf.ori
sed -i -e '$vm.swappiness=10' /etc/sysctl.conf
sysctl -p

# ==============================================================================

printf "\e[0;36m\n===== [EOF] =======\n\e[0m\n\n"