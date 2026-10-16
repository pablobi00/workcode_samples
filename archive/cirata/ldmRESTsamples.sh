#!/usr/bin/env bash

SERVER="52.10.54.138"

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION
#
# BASH REST samples
#
# Access to API list:
#
# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------


# create a verification

curl -X 'PUT' \
  'http://$SERVER:18080/verifications' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "migrationId": "cdp501db-managed",
  "ignoreAfterTimestamp": 0,
  "originalPaths": [
    "/warehouse/tablespace/managed/hive/cdp501db.db"
  ],
  "verificationDepth": 0
}'

# get all verifications

curl -X 'GET' \
  'http://$SERVER:18080/verifications/filtered' \
  -H 'accept: application/json'

 curl http://$SERVER:18080/verifications/filtered

# get verifications filtered by status IN_PROGRESS, QUEUED, COMPLETED, or CANCELLED

curl -X 'GET' \
  'http://$SERVER:18080/verifications/filtered?states=COMPLETE' \
  -H 'accept: application/json'

  curl http://$SERVER:18080/verifications/filtered?states=COMPLETE

# get verifications for a given migration

curl -X 'GET' \
  'http://$SERVER:18080/verifications/filtered?migrationIds=cdp501db-managed' \
  -H 'accept: application/json'

# get verification status 

curl http://$SERVER:18080/verifications/b08f1fd9-dcc3-49a0-85d8-a3112ab6a37f-1680134803317

# get verification reports listing

curl http://$SERVER:18080/verifications/b08f1fd9-dcc3-49a0-85d8-a3112ab6a37f-1680047400906/reports

# get verification status 

curl http://$SERVER:18080/verifications/b08f1fd9-dcc3-49a0-85d8-a3112ab6a37f-1680134803317


# Request path rescan

curl -X 'POST' \
  'http://$SERVER:18080/migrations/cdp501db-external/addPendingRegion?path=%2Fwarehouse%2Ftablespace%2Fexternal%2Fhive%2Fcdp501db.db&actionPolicy=com.wandisco.livemigrator2.migration.SkipIfSizeMatchActionPolicy' \
  -H 'accept: */*' \
  -d ''

curl -X POST http://$SERVER:18080/migrations/cdp501db-external/addPendingRegion?path=%2Fwarehouse%2Ftablespace%2Fexternal%2Fhive%2Fcdp501db.db&actionPolicy=com.wandisco.livemigrator2.migration.SkipIfSizeMatchActionPolicy




# Diagnostics

curl -X 'GET' \
  'http://$SERVER:18080/diagnostics/summary.txt' \
  -H 'accept: text/plain'

 curl http://$SERVER:18080/diagnostics/summary.txt
 curl http://$SERVER:18080/diagnostics/summary
