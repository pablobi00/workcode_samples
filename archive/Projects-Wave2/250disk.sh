#!/bin/bash

mkfs -t ext4 /dev/sdc1
mkdir /managed_disk
mount /dev/sdc1 /managed_disk
mkdir -p /managed_disk/opt/wandisco
chmod a+rx /managed_disk/opt/wandisco
ln -s /managed_disk/opt/wandisco /opt/wandisco
mkdir -p /managed_disk/var/log/fusion
chmod -R a+rx /managed_disk/var/log
ln -s /managed_disk/var/log/fusion /var/log/fusion
mkdir -p /managed_disk/etc/wandisco
chmod a+rx /managed_disk/etc/wandisco
ln -s /managed_disk/etc/wandisco /etc/wandisco

printf '\n=======\n[EOL]\n'
