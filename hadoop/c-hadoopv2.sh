#!/bin/bash

# Version 2.0 2021.03.15 - Install CDP 7.1.4 with option of CDH 6.3.4

printf '\e[31m\n===== [Cloudera] =====\n\e[0m'

wget https://<user_name>:<password>@archive.cloudera.com/cm7/7.1.4/cloudera-manager-installer.bin
chmod u+x cloudera-manager-installer.bin
./cloudera-manager-installer.bin

wget https://<user_name>:<password>@archive.cloudera.com/cdh7/7.1.4.0/parcels/CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel
wget https://<user_name>:<password>@archive.cloudera.com/cdh7/7.1.4.0/parcels/CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha1
wget https://<user_name>:<password>@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel
wget https://<user_name>:<password>@archive.cloudera.com/p/cdh6/6.3.4/parcels/CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha1

mv CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha1 CDH-7.1.4-1.cdh7.1.4.p0.6300266-el7.parcel.sha
mv CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha1 CDH-6.3.4-1.cdh6.3.4.p0.6626826-el7.parcel.sha
chown cloudera-scm:cloudera-scm CDH-*
cp CDH-* /opt/cloudera/parcel-repo/

printf '\e[31m\n===== [EOL] =====\n\n\e[0m'