#!/usr/bin/python3

import json
import requests


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
scanOnlyMigration = 'True'

print ('Source:',ldmurl,'\n======================================\n')

outputCode = [
    {'exitCode': 201, 'exitDescription': 'Migration added successfully'},
    {'exitCode': 400, 'exitDescription': 'Migration scanOnly value is not accepted'}, 
    {'exitCode': 403, 'exitDescription': 'Insufficient file system permissions to start migration'},
    {'exitCode': 404, 'exitDescription': 'Could not find the migration start path or file system'},
    {'exitCode': 409, 'exitDescription': 'Provided Migration Id or path already exists'},
    {'exitCode': 500, 'exitDescription': 'Source or Target file System is not accessible'}
]

pathsToMigrate = [
    {'migrationId': 'folder-a', 'pathTomigrate':'/data/folder-a'},
    {'migrationId': 'folder-b', 'pathTomigrate':'/data/folder-b'},
    {'migrationId': 'folder-c', 'pathTomigrate':'/data/folder-c'},
    {'migrationId': 'folder-d', 'pathTomigrate':'/data/folder-d'},
]

for createMigrations in pathsToMigrate:
   migrationName = (createMigrations ['migrationId'])
   pathToUse = (createMigrations ['pathTomigrate'])
   toCreate = (ldmurl + ':18080/migrations/' + migrationName + '?path=' + pathToUse +'&source=' + sourceFS + '&target=' + targetFS +'&actionPolicy=' + targetActionPolicy + '&autoStart=false&scanOnlyMigration=true' )
   migrationsAdded = requests.put(toCreate) 
   resultCode =  (migrationsAdded.status_code)
   print ( 'Migration ',migrationName,') with path: ',pathToUse,'Status:',resultCode)
   

# Start migrations

for startMigrations in pathsToMigrate:
   migrationName = (startMigrations ['migrationId'])
   toStart = (ldmurl + ':18080/migrations/' + migrationName + '/start')
   migrationStarted = requests.post(toStart) 
   print (migrationName,'- Start status:',migrationStarted)

print ('\n[EOF]\n')