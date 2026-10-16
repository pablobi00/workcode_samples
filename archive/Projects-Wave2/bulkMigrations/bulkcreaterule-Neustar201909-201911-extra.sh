#!/bin/bash

# Insert cookie from Login

SRCZONE="zoneBgen1"
TGTZONE="zoneBgen2"
COOKIE="Cookie: JSESSIONID=1i4k3xysqnpi91r5wsq63lej3u"
TOKEN="authn-token: 061ffbf5-016b-4911-9061-48d08ca9e83a"

# September 2019
# 20190901-20190909

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019090$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019090$i/"
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

# 20190910-20190930

for i in {10..30}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201909$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201909$i/"
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

# October 2019
# 20191001-20191009

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019100$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019100$i/"
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

# 20191010-20191031

for i in {10..31}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201910$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201910$i/"
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

#November 2019
# 20191101-20191109

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019110$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=2019110$i/"
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

# 20191110-20191130

for i in {10..30}
do
    RULENAME="W2 final - /data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201911$i/"
    RULEPATH="/data/raw/Marketing/AdActivity/Neustar/ver=01/LoadDate=201911$i/"
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