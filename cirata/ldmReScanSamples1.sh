#!/bin/bash

SERVER='44.230.76.62'
MIGRATION='db01-external'
MIG_PATH='/warehouse/tablespace/external/hive/db01.db'

# POLICY='com.wandisco.livemigrator2.migration.OverwriteActionPolicy'
POLICY='com.wandisco.livemigrator2.migration.SkipIfSizeMatchActionPolicy'


printf '\n ---------------------------------- Request path rescan ----------------------------------\n\n'

curl -X POST 'http://'$SERVER':18080/migrations/'$MIGRATION'/addPendingRegion?path='$MIG_PATH'&actionPolicy='$POLICY
curl -s 'http://'$SERVER':18080/migrations/'$MIGRATION'/pendingRegions' -H 'accept: application/json' > pathstatus.txt

tr -d '[]' < pathstatus.txt > pathstatus.json
printf '\n\nMigrationId: '$MIGRATION'\n'
jq '{path, actionPolicy, dateCreated}' pathstatus.json

printf '\n ---------------------------------- Migration Status --------------------------------------\n\n'

curl -s http://$SERVER:18080/migrations/$MIGRATION > status.json
jq '{migrationId, state, scannerSummary, numberPathsRequeued}' status.json