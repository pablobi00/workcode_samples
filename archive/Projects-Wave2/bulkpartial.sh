#!/usr/bin/env bash

# Insert cookie from Login

\$AUTHTO
echo "cookie = $COOKIE"
echo "token = $AUTHTOKEN"

# 2019-11-29/30 -----------------------------------

for i in {29..30}
do
    RULENAME="W2 final - /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-11-$i"
    RULEPATH="/data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-11-$i"
    echo "Creating rule called: $RULENAME-2019-11-$i"
done

# 2019-12-01/15 ----------------------------

for i in {1..9}
do
    RULENAME="W2 final - /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-12-0$i"
    RULEPATH="/data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-12-$i"
    echo "Creating rule called: $RULENAME-2019-12-$i"
done

for i in {10..15}
do
    RULENAME="W2 final - /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-12-$i"
    RULEPATH="/data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2019-12-$i"
    echo "Creating rule called: $RULENAME-2019-12-$i"
done

# 2020-01-10/31 ----------------------------


for i in {10..31}
do
    RULENAME="W2 final - /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2020-01-$i"
    RULEPATH="/data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/processDate=2020-01-$i"
    echo "Creating rule called: $RULENAME-2019-12-$i"
done

