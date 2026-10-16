#!/bin/bash

# Insert cookie from Login

SRCZONE="zone-central"
TGTZONE="zoneG2-central"
COOKIE="Cookie: JSESSIONID=1i4k3xysqnpi91r5wsq63lej3u"
TOKEN="authn-token: 061ffbf5-016b-4911-9061-48d08ca9e83a"

# March 2019
# 20190325 - 20190331

for i in {25..31}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201903$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201903$i/"
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

# April 2019
# 20190401-20190409

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019040$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019040$i/"
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

# 20190410-20190430

for i in {10..30}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201904$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201904$i/"
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

# May 2019
# 20190501-20190509

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019050$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019050$i/"
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

# 20190510-20190531

for i in {10..31}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201905$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201905$i/"
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

# June 2019
# 20190601-20190609


for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019060$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019060$i/"
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

# 20190610-20190630

for i in {10..30}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201906$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201906$i/"
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

# July 2019

# 20190701-20190709

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019070$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019070$i/"
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

# 20190710-20190731

for i in {10..31}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201907$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201907$i/"
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

# August 2019
# 20190801-20190809

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019080$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019080$i/"
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

# 20190810-20190831

for i in {10..31}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201908$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201908$i/"
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