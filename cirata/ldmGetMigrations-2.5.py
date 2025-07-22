#!/usr/bin/python3

import json
import requests
from colorama import Fore

cBlue = (Fore.BLUE)
cGreen = (Fore.GREEN)
cReset = (Fore.RESET)

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION
# Searches for all migrations, it includes different examples of information and statistics

# Access to API list:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------


print (cBlue+'---- GET MIGRATION INFORMATION --------------------------\n'+cReset)

# Get migrations list

ldmurl='http://52.10.54.138'
print (cGreen+'Source:'+cReset,ldmurl,'\n======================================\n')
allData3 = requests.get(ldmurl + ':18080/migrations').json()

# Quick migration state summary

partialKeysList=[
    'migrationId',
    'path',
    'source',
    'target',
    'targetActionPolicy',
    'recurringMigration',
    'scanOnlyMigration'
  ]

for i in allData3:
    if isinstance(i, dict):
        print (cBlue+'\n-----------------\n'+cReset)
        for key, value in i.items():
            if key in partialKeysList:
                print(cGreen+key,': '+cReset, value)

print (cBlue+'[EOF]'+cReset)