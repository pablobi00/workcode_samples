#!/bin/bash

# Initialization variables

SERVER='44.230.76.62'
MIGRATION='db01-external'
MIG_PATH='/warehouse/tablespace/external/hive/db01.db'
SOURCE_FS='auto-discovered-source-hdfs'

# POLICY='com.wandisco.livemigrator2.migration.OverwriteActionPolicy'
POLICY='com.wandisco.livemigrator2.migration.SkipIfSizeMatchActionPolicy'


printf '\n ---------------------------------- Request path rescan ----------------------------------\n\n'

# First call start the path rescan, second call shows the status of the rescna itself.

curl -X POST 'http://'$SERVER':18080/migrations/'$MIGRATION'/addPendingRegion?path='$MIG_PATH'&actionPolicy='$POLICY
curl -s 'http://'$SERVER':18080/migration-path-status?path='$MIG_PATH'&sourceId='$SOURCE_FS

printf '\n ---------------------------------- Migration Status --------------------------------------\n\n'

# After the call to rescan is submitted, a new job for the migration is scheduled for execution

curl -s http://$SERVER:18080/migrations/$MIGRATION > status.json
jq '{migrationId, state, scannerSummary}' status.json

MIG_STATE=$(cat status.json | jq -r '.state')

printf '\n\n ---------------------------------- Waiting for Rescan to Complete --------------------------------------\n\n'

# This loop will display the states of the migraiton, as it goes through SCHEDULED, RUNNIGN to COMPLETED or LIVE. 
# NOTE - Not all file system support LIVE migrations. For exampel ADLS Gen2 and Local storage do NOT support LIVE. 
# It prints the time when each status is set.

COUNTER=0

while [ $MIG_STATE != 'COMPLETED' ] | [ $MIG_STATE != 'LIVE' ]
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

