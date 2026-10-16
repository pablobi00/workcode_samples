#!/usr/bin/python3

import json
import requests


print ('---- GET MIGRATION INFORMATION --------------------------\n')

# LDM serer DNS/IP address
 
ldmurl='http://pablob-centos-001a.westus2.cloudapp.azure.com'

# Get a list of all migration

allMigrations = requests.get(ldmurl + ':18080/migrations').json()
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

# For all migrations added to the in the dictionary, the rescan is launced.

for key, subDict in allCompleted.items():
    migId = key
    print (migId)
    for subDict_key,subKey_value in subDict.items():
        # print ('\t',subDict_key,subKey_value)
        if subDict_key == 'Path':
            wherePath = subKey_value
            toReScan = (ldmurl + ':18080/migrations/' + migId + '/addPendingRegion?' + 'path=' + wherePath  + '&actionPolicy=' + policyScan)
            reScan = requests.post (toReScan)
            if reScan.status_code == 200:
                print ("Success")
                whatReScanned = (ldmurl + ':18080/migrations/' + migId + '/pendingRegions')
                seeReScans = requests.get (whatReScanned).json()
                print (seeReScans)
            else:
                print ('ERROR: ',reScan.status_code)
