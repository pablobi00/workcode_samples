#!/usr/bin/python3

import json
import requests

from colorama import Fore

cBlue = (Fore.BLUE)
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


print ('---- GET MIGRATION INFORMATION --------------------------\n')

# Get migrations list

ldmurl='http://20.112.32.14'
print ('Source:',ldmurl,'\n======================================\n')
allData3 = requests.get(ldmurl + ':18080/migrations').json()

# Quick migration state summary

partialKeysList=[
    'migrationId',
    'path',
    'source',
    'target',
    'state',
    'targetActionPolicy',
    'migrationCreatedTime',
    'migrationStartTime',
    'migrationCompleteTime',
    'scannerSummary'
]

for i in allData3:
    if isinstance(i, dict):
        print ('\n============================\n')
        print (i['state'],i['migrationId'])
        print('\n-----------------\n')
        for key, value in i.items():
            if key in partialKeysList:
                print(key, ': ', value)


# Current active migrations statistics
'''
for i in allData3:
    uglyJson = (requests.get(ldmurl + ':18080/stats/',i['migrationId']).json())
    print (json.dumps(uglyJson,indent=4))
'''
print (cBlue+'\n=====\n[EOF]\n=====\n'+cReset)