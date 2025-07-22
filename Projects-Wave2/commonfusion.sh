#!/bin/bash

# network startup parameters

sed -i '/# End of file/i \
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
net.core.netdev_budget = 600\
net.core.somaxconn = 1024\
net.ipv4.tcp_slow_start_after_idle = 0\
net.core.default_qdisc = fq' /etc/sysctl.conf

echo "FUSION_EXTRA_JVM_ARGS='-Dhttp.maxConnections=100 -Dcom.wandisco.shadow.io.netty.eventLoopThreads=128'" >> /etc/wandisco/fusion/ihc/server/hdi-4.0/fusion_env.sh
echo "FUSION_EXTRA_JVM_ARGS='-Dhttp.maxConnections=100 -Dcom.wandisco.shadow.io.netty.eventLoopThreads=128'" >> /etc/wandisco/fusion/server/fusion_env.sh

# Set transmission queue lengths for NICs
/sbin/ifconfig eth0 txqueuelen 10000

# Set rx and tx buffers
ethtool -g eth0
ethtool -G eth0 rx 18811 tx 2560

# permissions

chown -R hdfs:hdfs /etc/wandisco/fusion

# Fusion file structure

mkdir /opt/wandisco/fusion/client
mkdir /opt/wandisco/fusion/client/lib /opt/wandisco/fusion/client/jars
touch /opt/wandisco/fusion/client/jars/fusion-client-2.14.jar

printf  "\n=====\n[EOL]\n"