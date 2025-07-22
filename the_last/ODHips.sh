#!/bin/bash

rm external_ips.json

declare -A ARRAY=(
    [pablobown0]=11.0.0.36
    [pablobown1]=11.0.0.61 
    [pablobown2]=11.0.0.29 
    [pablobomn0]=11.0.0.11 
    [pabloboun0]=11.0.0.13
    ) 

export SUBNET_OCID="ocid1.subnet.oc1.phx.<OCID>"

for i in ${!ARRAY[@]}
do
    export DISPLAY_NAME=$i
    export PRIVATE_IP=${ARRAY[$i]}
    echo "$DISPLAY_NAME ---> $PRIVATE_IP"
    oci network public-ip create --display-name $DISPLAY_NAME --compartment-id `oci network private-ip list --subnet-id $SUBNET_OCID --ip-address $PRIVATE_IP | jq -r '.data[] | ."compartment-id"'` --lifetime "RESERVED" --private-ip-id `oci network private-ip list --subnet-id $SUBNET_OCID --ip-address $PRIVATE_IP | jq -r '.data[] | ."id"'` >> external_ips.json

done

jq '.data | .["display-name"] + " --> " + .["ip-address"]' external_ips.json > ip_list.txt
cat ip_list.txt
