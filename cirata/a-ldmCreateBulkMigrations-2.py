#!/usr/bin/python3

import json
import requests
from colorama import Fore

cBlue = (Fore.BLUE)
cReset = (Fore.RESET)

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION
# Creates migrations and starts them

# Access to API list:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------


ldmurl='http://44.230.76.62'
sourceFS = 'auto-discovered-source-hdfs'
targetFS = 'gen2-002'
targetActionPolicy = 'com.wandisco.livemigrator2.migration.SkipIfSizeMatchActionPolicy'
scanOnlyMigration = 'true'
autoStart = 'false'

print ('Source:',ldmurl,'\n======================================\n')

# Migrations list
# migrationId = the name of the migration
# pathTomigrate = the path in relationship to the LDM Source FS 

pathsToMigrate = [
    {'migrationId': 'folder-a', 'pathTomigrate':'/data/folder-a'},
    {'migrationId': 'folder-b', 'pathTomigrate':'/data/folder-b'},
    {'migrationId': 'folder-c', 'pathTomigrate':'/data/folder-c'},
    {'migrationId': 'folder-d', 'pathTomigrate':'/data/folder-d'},
]

# Create migrations

for createMigrations in pathsToMigrate:
   migrationName = (createMigrations ['migrationId'])
   pathToUse = (createMigrations ['pathTomigrate'])

   toCreate = (ldmurl + ':18080/migrations/' + migrationName + '?path=' + pathToUse +'&source=' + sourceFS + '&target=' + targetFS +'&actionPolicy=' + targetActionPolicy + '&autoStart=' + autoStart + '&scanOnlyMigration=true' )

   migrationsAdded = requests.put(toCreate) 
   resultCode =  (migrationsAdded.status_code)
   print ( 'Migration ',migrationName,' with path ',pathToUse,' - create status:',resultCode)
   
# Start migrations

for startMigrations in pathsToMigrate:
   migrationName = (startMigrations ['migrationId'])
   toStart = (ldmurl + ':18080/migrations/' + migrationName + '/start')
   migrationStarted = requests.post(toStart) 
   print (migrationName,'- Start status:',migrationStarted)

print (cBlue+'\n[EOF]\n'+cReset)