#!/bin/bash

# ------------------------------------------------------------------


# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION

# Launch migration rescan for an specific migration, then shows as it changes its state, until it completes
# This script is for static migrations since it does not considers LIVE status


# Access to API list:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------


# Initialization variables

SERVER='44.230.76.62'
MIGRATION='db01-external'
MIG_PATH='/warehouse/tablespace/external/hive/db01.db'
SOURCE_FS='auto-discovered-source-hdfs'

# POLICY='com.wandisco.livemigrator2.migration.OverwriteActionPolicy'
POLICY='com.wandisco.livemigrator2.migration.SkipIfSizeMatchActionPolicy'


printf '\n ---------------------------------- Request path rescan ----------------------------------\n\n'

# First call start the path rescan, second call shows the status of the rescan itself.

curl -X POST 'http://'$SERVER':18080/migrations/'$MIGRATION'/addPendingRegion?path='$MIG_PATH'&actionPolicy='$POLICY
curl -s 'http://'$SERVER':18080/migration-path-status?path='$MIG_PATH'&sourceId='$SOURCE_FS

printf '\n ---------------------------------- Migration Status --------------------------------------\n\n'

# After the call to rescan is submitted, a new job for the migration is scheduled for execution

curl -s http://$SERVER:18080/migrations/$MIGRATION > status.json
jq '{migrationId, state, scannerSummary}' status.json

MIG_STATE=$(cat status.json | jq -r '.state')

printf '\n\n ---------------------------------- Waiting for Rescan to Complete --------------------------------------\n\n'

# This loop will display the states of the migraiton, as it goes through SCHEDULED, RUNNING to COMPLETED. 
# It prints the time when each state is set.

COUNTER=0

while [ $MIG_STATE != 'COMPLETED' ]
do
    curl -s http://$SERVER:18080/migrations/$MIGRATION > status.json
    MIG_STATE=$(cat status.json | jq -r '.state')
    DATES=$(date +"%Y-%m-%d %a %T %Z/UTC%z")
    if [[ $MIG_STATE == 'SCHEDULED'  &&  $COUNTER == 0 ]]; 
      then
        printf 'SCHEDULED - %s\n' "$DATES"
        COUNTER=1
    elif [[ $MIG_STATE == 'RUNNING'  &&  $COUNTER == 1 ]]; 
      then
       printf 'RUNNING - %s\n' "$DATES"
       COUNTER=2
    fi
done

DATES=$(date +"%Y-%m-%d %a %T %Z/UTC%z")
printf '%s - %s\n' "$MIG_STATE" "$DATES"

printf '\n\n ---------------------------------- Rescan Completed --------------------------------------\n\n'

# Final status - it looks for pending paths to be migrated and for the overall status of the migration

curl -s 'http://'$SERVER':18080/migration-path-status?path='$MIG_PATH'&sourceId='$SOURCE_FS
curl -s http://$SERVER:18080/migrations/$MIGRATION > status.json
jq '{migrationId, state, scannerSummary}' status.json

