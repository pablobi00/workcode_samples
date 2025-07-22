#!/bin/bash

# network startup parameters

printf '\n
net.ipv4.tcp_keepalive_intvl=15\n
net.ipv4.tcp_keepalive_probes=5\n
net.ipv4.tcp_mem = 1543344      2057794 6086688\n
net.core.wmem_max = 16777216\n
net.core.rmem_max = 16777216\n
net.core.wmem_default = 4194304\n
net.core.rmem_default = 4194304\n
net.core.netdev_max_backlog = 4096\n
net.ipv4.tcp_wmem = 4096 16384 16777216\n
net.ipv4.tcp_rmem = 4096 87380 16777216\n
net.ipv4.tcp_max_syn_backlog = 2048\n
net.core.netdev_budget = 600\n
net.core.somaxconn = 1024\n
net.ipv4.tcp_slow_start_after_idle = 0\n
net.core.default_qdisc = fq' >> testfile

echo "\nFUSION_EXTRA_JVM_ARGS='-Dhttp.maxConnections=100 -Dcom.wandisco.shadow.io.netty.eventLoopThreads=128'" >> testfile
echo "\nFUSION_EXTRA_JVM_ARGS='-Dhttp.maxConnections=100 -Dcom.wandisco.shadow.io.netty.eventLoopThreads=128'" >> testfile

printf  "\n=====\n[EOL]\n"