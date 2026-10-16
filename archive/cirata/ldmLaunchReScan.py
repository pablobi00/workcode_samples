#!/usr/bin/python3

import json
import requests


print ('---- GET MIGRATION INFORMATION --------------------------\n')

ldmurl='http://44.230.76.62'
print (ldmurl)

allMigrations = requests.get(ldmurl + ':18080/migrations').json()
allCompleted = []

for i in allMigrations:
    if isinstance(i, dict):
        for key, value in i.items():
            theKey = key
            if theKey == 'migrationId':
                migId = (value)
            if theKey=='state':
                if value=='COMPLETED':
#                   print(str(migId),(value))
                   allCompleted = allCompleted + [migId]

print (allCompleted)
print (allMigrations)

            
