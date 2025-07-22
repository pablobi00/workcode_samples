#!/usr/bin/python3

import json
import requests

from colorama import Fore

cStart = (Fore.LIGHTGREEN_EX)
cReset = (Fore.RESET)

# ------------------------------------------------------------------
# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION

# Searches for all migrations and gets a few fields

# Access to API list outside localhost:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html
# ------------------------------------------------------------------

print (cStart+'\n' + 5*'=', 'GET MIGRATION INFORMATION', 5*'=' + '\n' + cReset)

# source ip
# ldmurl='http://127.0.0.1'
ldmurl='http://4.242.58.128'
print ('Source:',ldmurl+'...')

# Get migrations list

print ('Get migration list...')
allData3 = requests.get(ldmurl + ':18080/migrations').json()

# Open a file for writing

print ('Write output file output.txt...')
with open('output.txt', 'w') as archivo:
    for i in allData3:
        toWrite = str(( i['migrationId'],i['internalId'],i['path']))
#        toWrite2 = '\nUser defined exclusion rules:' + str((i['userDefinedExclusions']))
        archivo.write (toWrite+'\n')

print (cStart+'\n=====\nEOF\n=====\n'+cReset)