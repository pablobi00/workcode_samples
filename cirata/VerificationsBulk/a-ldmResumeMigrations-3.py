#!/usr/bin/python3

import json
import requests

from colorama import Fore

cBlue = (Fore.BLUE)
cReset = (Fore.RESET)

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION
#
# Resumes migrations based on the Id in the migrationsToResume.json file. 
#
# THERE IS NO ERROR VERIFICATION
#
# Access to API list:

# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html

# ------------------------------------------------------------------

# Initialization variables

ldmurl='http://52.10.54.138'

# ------------------- Get migrations list to RESUME -------------------- #


with open('migrationsToResume.json', 'r') as infile:
    toResume = json.load(infile)

# ------------------- RESUME migrations -------------------- #

print (cBlue+'\nMigrations:\n'+cReset)
for migId in toResume:
    resumeMigration = requests.post(ldmurl+':18080/migrations/'+migId+'/resume')
    print (migId,'has resumed')