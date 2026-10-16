#!/usr/bin/python3

import json
import requests

from colorama import Fore

cBlue = (Fore.BLUE)
cReset = (Fore.RESET)

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION
# Gets a list current of migrations with pending regions - either scheduled or running.

# Access to API list:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------



ldmurl='http://pablob-centos-001a.westus2.cloudapp.azure.com'

allMigrations = requests.get(ldmurl + ':18080/migrations').json()

for i in allMigrations:
    if isinstance(i, dict):
        for key, value in i.items():
            if key == 'migrationId':
                migId = (value)
                whatReScanned = (ldmurl + ':18080/migrations/' + migId + '/pendingRegions')
                seeReScans = requests.get (whatReScanned).json()
#                print (migId,seeReScans)
#                if seeReScans:
#                    activeMigrations = requests.get (ldmurl + ':18080/migrations/' + migId).json()
#                    print (migId,seeReScans)
#                    formatted_activeMigrations = json.dumps (activeMigrations, indent = 4)
#                    print (formatted_activeMigrations)
            if key == "state":
                migStateKey = (value)
                print ('\nMigration: ',migId,'\n- Active rescan: ', seeReScans, '\n- Migration state: ', migStateKey,'\n')

print (cBlue+'EOF'+cReset)