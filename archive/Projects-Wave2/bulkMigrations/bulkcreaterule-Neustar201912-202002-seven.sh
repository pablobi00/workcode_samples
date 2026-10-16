#!/bin/bash

# Insert cookie from Login

SRCZONE="zoneCgen1"
TGTZONE="zoneCgen2"
COOKIE="Cookie: JSESSIONID=1i4k3xysqnpi91r5wsq63lej3u"
TOKEN="authn-token: 061ffbf5-016b-4911-9061-48d08ca9e83a"

# December 2019
# 20191201-20191209

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019120$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019120$i/"
    echo "Creating rule called: $RULENAME"
    curl -v \
    --header "Accept: application/json, text/plain, */*" \
    --header "Content-Type: application/json;charset=UTF-8" \
    --header "$COOKIE" \
    --header "$TOKEN" \
    --data "{\"replicatedFolder\":{\"zones\":[{\"local\":false,\"id\":\"$TGTZONE\",\"name\":\"$TGTZONE\"},{\"local\":true,\"id\":\"$SRCZONE\",\"name\":\"$SRCZONE\"}],\"priorityZone\":\"$SRCZONE\",\"pathMap\":{\"$TGTZONE\":\"$RULEPATH\",\"$SRCZONE\":\"$RULEPATH\"},\"name\":\"$RULENAME\",\"excluded\":[\"/**/.Trash/**\",\"/**/.hive-staging**\",\"/**/.snapshot/\",\"/**/.snapshot\",\"/**/.Trash\"],\"scheduleChecks\":false}}" \
    --insecure \
    https://localhost:8443/api/replicatedFolders
done

# 20191210-20191231

for i in {10..31}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201912$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201912$i/"
    echo "Creating rule called: $RULENAME"
    curl -v \
    --header "Accept: application/json, text/plain, */*" \
    --header "Content-Type: application/json;charset=UTF-8" \
    --header "$COOKIE" \
    --header "$TOKEN" \
    --data "{\"replicatedFolder\":{\"zones\":[{\"local\":false,\"id\":\"$TGTZONE\",\"name\":\"$TGTZONE\"},{\"local\":true,\"id\":\"$SRCZONE\",\"name\":\"$SRCZONE\"}],\"priorityZone\":\"$SRCZONE\",\"pathMap\":{\"$TGTZONE\":\"$RULEPATH\",\"$SRCZONE\":\"$RULEPATH\"},\"name\":\"$RULENAME\",\"excluded\":[\"/**/.Trash/**\",\"/**/.hive-staging**\",\"/**/.snapshot/\",\"/**/.snapshot\",\"/**/.Trash\"],\"scheduleChecks\":false}}" \
    --insecure \
    https://localhost:8443/api/replicatedFolders
done

# Junuary 2020
# 20200101-20200101


for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2020010$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2020010$i/"
    echo "Creating rule called: $RULENAME"
    curl -v \
    --header "Accept: application/json, text/plain, */*" \
    --header "Content-Type: application/json;charset=UTF-8" \
    --header "$COOKIE" \
    --header "$TOKEN" \
    --data "{\"replicatedFolder\":{\"zones\":[{\"local\":false,\"id\":\"$TGTZONE\",\"name\":\"$TGTZONE\"},{\"local\":true,\"id\":\"$SRCZONE\",\"name\":\"$SRCZONE\"}],\"priorityZone\":\"$SRCZONE\",\"pathMap\":{\"$TGTZONE\":\"$RULEPATH\",\"$SRCZONE\":\"$RULEPATH\"},\"name\":\"$RULENAME\",\"excluded\":[\"/**/.Trash/**\",\"/**/.hive-staging**\",\"/**/.snapshot/\",\"/**/.snapshot\",\"/**/.Trash\"],\"scheduleChecks\":false}}" \
    --insecure \
    https://localhost:8443/api/replicatedFolders
done

# 20200110-20200131

for i in {10..31}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=202001$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=202001$i/"
    echo "Creating rule called: $RULENAME"
    curl -v \
    --header "Accept: application/json, text/plain, */*" \
    --header "Content-Type: application/json;charset=UTF-8" \
    --header "$COOKIE" \
    --header "$TOKEN" \
    --data "{\"replicatedFolder\":{\"zones\":[{\"local\":false,\"id\":\"$TGTZONE\",\"name\":\"$TGTZONE\"},{\"local\":true,\"id\":\"$SRCZONE\",\"name\":\"$SRCZONE\"}],\"priorityZone\":\"$SRCZONE\",\"pathMap\":{\"$TGTZONE\":\"$RULEPATH\",\"$SRCZONE\":\"$RULEPATH\"},\"name\":\"$RULENAME\",\"excluded\":[\"/**/.Trash/**\",\"/**/.hive-staging**\",\"/**/.snapshot/\",\"/**/.snapshot\",\"/**/.Trash\"],\"scheduleChecks\":false}}" \
    --insecure \
    https://localhost:8443/api/replicatedFolders
done

# February 2020
# 20200201-20200201


for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2020020$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2020020$i/"
    echo "Creating rule called: $RULENAME"
    curl -v \
    --header "Accept: application/json, text/plain, */*" \
    --header "Content-Type: application/json;charset=UTF-8" \
    --header "$COOKIE" \
    --header "$TOKEN" \
    --data "{\"replicatedFolder\":{\"zones\":[{\"local\":false,\"id\":\"$TGTZONE\",\"name\":\"$TGTZONE\"},{\"local\":true,\"id\":\"$SRCZONE\",\"name\":\"$SRCZONE\"}],\"priorityZone\":\"$SRCZONE\",\"pathMap\":{\"$TGTZONE\":\"$RULEPATH\",\"$SRCZONE\":\"$RULEPATH\"},\"name\":\"$RULENAME\",\"excluded\":[\"/**/.Trash/**\",\"/**/.hive-staging**\",\"/**/.snapshot/\",\"/**/.snapshot\",\"/**/.Trash\"],\"scheduleChecks\":false}}" \
    --insecure \
    https://localhost:8443/api/replicatedFolders
done

# 20200226-20200226

for i in {10..26}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=202002$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=202002$i/"
    echo "Creating rule called: $RULENAME"
    curl -v \
    --header "Accept: application/json, text/plain, */*" \
    --header "Content-Type: application/json;charset=UTF-8" \
    --header "$COOKIE" \
    --header "$TOKEN" \
    --data "{\"replicatedFolder\":{\"zones\":[{\"local\":false,\"id\":\"$TGTZONE\",\"name\":\"$TGTZONE\"},{\"local\":true,\"id\":\"$SRCZONE\",\"name\":\"$SRCZONE\"}],\"priorityZone\":\"$SRCZONE\",\"pathMap\":{\"$TGTZONE\":\"$RULEPATH\",\"$SRCZONE\":\"$RULEPATH\"},\"name\":\"$RULENAME\",\"excluded\":[\"/**/.Trash/**\",\"/**/.hive-staging**\",\"/**/.snapshot/\",\"/**/.snapshot\",\"/**/.Trash\"],\"scheduleChecks\":false}}" \
    --insecure \
    https://localhost:8443/api/replicatedFolders
done

printf '\n=====\n[EOL]\n'