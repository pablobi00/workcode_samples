#!/bin/bash

# Insert cookie from Login

SRCZONE="zone-central"
TGTZONE="zoneG2-central"
COOKIE="Cookie: JSESSIONID=1i4k3xysqnpi91r5wsq63lej3u"
TOKEN="authn-token: 061ffbf5-016b-4911-9061-48d08ca9e83a"

for i in {29..30}
do
    RULENAME="W2 final - /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-11-$i/"
    RULEPATH="/data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-11-$i/"
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


# 2019-12-01/15 ----------------------------

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-12-0$i/"
    RULEPATH="/data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-12-0$i/"
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

for i in {10..15}
do
    RULENAME="W2 final - /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-12-$i/"
    RULEPATH="/data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-12-$i/"
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

# 2020-01-10/31 ----------------------------


for i in {10..31}
do
    RULENAME="W2 final - /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2020-01-$i/"
    RULEPATH="/data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2020-01-$i/"
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
