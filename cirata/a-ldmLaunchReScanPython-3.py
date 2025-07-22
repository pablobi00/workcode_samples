#!/usr/bin/python3

import json
import requests
from colorama import Fore

cBlue = (Fore.BLUE)
cReset = (Fore.RESET)

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION

# Searches for all completed migrations and launches a rescan for those with state=COMPLETE
# This script is for static migrations since it does not considers LIVE state

# Access to API list:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------


print ('---- GET MIGRATION INFORMATION --------------------------\n')

# LDM server DNS/IP address


ldmurl='44.230.76.62'

# Get a list of all migration

allMigrations = requests.get('http://'+ldmurl + ':18080/migrations').json()
allCompleted = {}
policyScan = 'com.wandisco.livemigrator2.migration.SkipIfSizeMatchActionPolicy'

# If migration is in a COMPELTED status it is added to a dictionary of migrations to be rescanned.

for i in allMigrations:
    if isinstance(i, dict):
        for key, value in i.items():
            if key == 'migrationId':
                migId = (value)
            if key == 'path':
                pathToscan = value
            if key =='state':
                if value=='COMPLETED':
                    stateIs = value
                    allCompleted[migId] = {'State':stateIs,'Path':pathToscan}

# For all migrations added to the dictionary, the rescan is launced.

for key, subDict in allCompleted.items():
    migId = key
    print (migId)
    for subDict_key,subKey_value in subDict.items():
        # print ('\t',subDict_key,subKey_value)
        if subDict_key == 'Path':
            wherePath = subKey_value
            toReScan = ('http://'+ldmurl + ':18080/migrations/' + migId + '/addPendingRegion?' + 'path=' + wherePath  + '&actionPolicy=' + policyScan)
            reScan = requests.post (toReScan)
            if reScan.status_code == 200:
                print ("Success")
                whatReScanned = ('http://'+ldmurl + ':18080/migrations/' + migId + '/pendingRegions')
                seeReScans = requests.get (whatReScanned).json()
                print (seeReScans)
            else:
                print ('ERROR: ',reScan.status_code)

print (cBlue+'\n=====[EOF]\n=====\n'+cReset)