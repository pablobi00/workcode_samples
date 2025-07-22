#!/usr/bin/python3

import json
import requests

addMigration = requests.put('http://pablob-ubuntu18-001a.westus2.cloudapp.azure.com:18080/migrations/g2tog2-folder-b?path=%2Ffolder-b&source=g2-west2&target=g2-east&actionPolicy=com.wandisco.livemigrator2.migration.OverwriteActionPolicy&autoStart=true&scanOnlyMigration=true').json()

print('='*20)

if 'error' in addMigration:
    print('ERROR - identification number', addMigration.get('error') )
    print ('What happened:', addMigration.get('title'))
    print('\nDetails',json.dumps(addMigration, indent=4))
else:
   print ('Success - Migration',addMigration.get ('migrationId'),'created.' ) 

print('='*10, '[EOF]', '='*10)

