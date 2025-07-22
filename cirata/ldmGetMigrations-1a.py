#!/usr/bin/python3

import json
import requests


print ('---- GET MIGRATION INFORMATION --------------------------\n')

ldmurl='http://44.230.76.62'
print ('Source:',ldmurl,'\n======================================\n')

allData3 = requests.get(ldmurl + ':18080/migrations').json()

for i in allData3:
    if isinstance(i, dict):
        for key, value in i.items():
#             theKey = key
#            if theKey=='migrationId: ' or theKey=='state':
            print(key, value)
