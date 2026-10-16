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

# Get migrations list

curl http://ec2-52-10-54-138.us-west-2.compute.amazonaws.com:18080/migrations -o migrations.json
# sed 's/\[//g' migrations.json > m1.json && sed 's/\]//g' migrations.json > m1.json
# jq '{migrationId,state}' m1.json > toVerify.json
tr -d '['  < migrations.json > mt1.json
tr -d ']'  < mt1.json >  mt3.json
jq '{migrationId,state}' mt3.json > toVerify.json