#!/bin/bash

# script will launch a LiveMigrator process from Gen1 --> Gen2 
# After 20 seconds it will stop the Fusion Server in the Gen2 Zone
# Fusion server will be restarted after 20 seconds

# Usage: # lm-drtest.sh /pathtomigrate

# Execute in the gen2 server

PATHTOMIGRATE=$1
GEN1HOST=fusion-centos-central-zn1-01
GEN1=gen1-central-z1
GEN2=gen2-east2-z1

printf '===== Path to migrate - %s from %s to %s\n===== Using Node %s\n' $PATHTOMIGRATE $GEN1 $GEN2 $GEN1HOST
read -p "---> [enter to continue]"

# curl -v -X GET http://$GEN1HOST:8082/fusion

curl -v -X PUT http://$GEN1HOST:8082/plugins/migrator/migrate?path=$PATHTOMIGRATE\&beneficiary=$GEN2\&donor=$GEN1\&iterationLimit=1000

i=11; while [ $i -gt 0 ]; do printf '> Waiting warm-up and LM start - %s \r' $i; i=`expr $i - 1`; sleep 1;  done

printf '\n==============   Stopping Fusion proccess in Gen2 server\n'

/etc/init.d/fusion-server stop

i=45; while [ $i -gt 0 ]; do printf '> Waiting to restart process - %s \r' $i; i=`expr $i - 1`; sleep 1;  done

printf '\n ===============  Re-starting Fusion process in Gen2 server\n'

/etc/init.d/fusion-server start 
/etc/init.d/fusion-server status

printf '\n ==== Check eMail client for alerts\n'

printf '\n=======\n[EOL]\n'