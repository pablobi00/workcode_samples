#!/usr/bin/python3

import json
import requests

from colorama import Fore
from requests.api import get

cBlue = (Fore.BLUE)
cReset = (Fore.RESET)

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION
#
# Creates verifications for all migrations.
# Resumes verifications stopped
#
# Access to API list:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------

# Initialization variables

ldmurl='http://52.10.54.138'
ignoreAfterTimestamp=0
verificationDepth=0

allVerificationsCreated = {}


print ('---- GET MIGRATIONS INFORMATION --------------------------\n')

# Get migrations list

allMigrations = requests.get(ldmurl + ':18080/migrations').json()

# ---------- Getting migration status and parameters ------------------ #

for i in allMigrations:

    migId = i["migrationId"]
    status = i["state"]
    pathM = i["path"]

    toResume = 'null'

    print ('Verifiction to be created for',migId,'with path',pathM,'\nCurrent state:',status,'\n')

# ------------------ Stop idle recurring migrations ------------------ #

    if status == 'WAITING_FOR_NEXT_RECURRENCE':
        stopMigration = requests.post(ldmurl+':18080/migrations/'+migId+'/stop?resumable=true')
        toResume = migId
        print ('\nMigration',migId,'has been stopped')

# ------------------ Create Verifications ------------------ #

    url = ldmurl+':18080/verifications'
    headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json'
    }
    data = {
        "migrationId": migId,
        "ignoreAfterTimestamp": 0,
        "originalPaths": [
            pathM
        ],
        "verificationDepth": 0
    }
    newVerifications = requests.put(url, headers=headers, json=data)
    verificationData = newVerifications.json()
    verificationId = (verificationData['id'])

# ---------------- Migrations and the id verifications created -------------------- #

    allVerificationsCreated[migId]=verificationId

# ------------------ Resume recurring migrations ------------------ #

    if toResume != 'null':
        resumeMigration = requests.post(ldmurl+':18080/migrations/'+migId+'/resume')
        print (migId,'has resumed')

print (allVerificationsCreated)
with open('verificationsList.json', 'w') as outfile:
    json.dump(allVerificationsCreated, outfile)

print (cBlue+'\n=====\n[EOF]\n=====\n'+cReset)