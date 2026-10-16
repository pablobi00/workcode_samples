#!/usr/bin/python3

import json
import requests

from colorama import Fore

cStart = (Fore.LIGHTGREEN_EX)
cReset = (Fore.RESET)
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

# ------------------------------------------------------------------
# Q. What is happening here?
#
# A. The script will get the name of migrations and then the current 
#    livedata-migrator.log byteCounts for all migrations.
#
#    One way to use it:
#        Grab the name of a migraition from the top.
#        Then do a  #grep <migration name> output.txt | grep byteCount
#
#    You can get historicals by getting logs from the archive under
#    /var/log/wandisco/livedata-migrator/ 
# ------------------------------------------------------------------


print (cStart+'\n' + 5*'=', 'GET MIGRATION INFORMATION', 5*'=' + '\n' + cReset)

# source ip
ldmurl='http://127.0.0.1'
print ('Source:',ldmurl+'...')

# Get migrations list

print ('Get migration list...')
allData3 = requests.get(ldmurl + ':18080/migrations').json()

with open('output.txt', 'w') as archivo:
    for i in allData3:
        toWrite = str(( i['migrationId']))
        archivo.write (toWrite+'\n')

    find_text = 'byteCount'
    file_name='/var/log/wandisco/livedata-migrator/livedata-migrator.log'

    with open(file_name, 'r') as file:
        for line in file:
            if find_text in line:
                toWrite=(line.strip())
                archivo.write (toWrite+'\n')

print (cStart+'\n=====\nEOF\n=====\n'+cReset)