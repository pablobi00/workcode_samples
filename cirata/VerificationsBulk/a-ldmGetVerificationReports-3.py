#!/usr/bin/python3

import json
import requests

from colorama import Fore

cBlue = (Fore.BLUE)
cReset = (Fore.RESET)

# ------------------------------------------------------------------

# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION
#
# Get verification reports from the list in the verificationsList.json file. 
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


with open('verificationsList.json', 'r') as infile:
    verificationReports = json.load(infile)

# ------------------- RESUME migrations -------------------- #

print (cBlue+'\nMigrations:\n'+cReset)

for key, value in verificationReports.items():
    print ('Migration Id:',key,'- report Id:',value)
    url = ldmurl+':18080/verifications/reports/'+value 
    headers = {'accept': 'application/x-tar'}
    downloadReport = requests.get(url, headers=headers)
    if downloadReport.status_code == 200:
        with open("report-"+key+"-"+value+".tar.gz", "wb") as f:
             f.write(downloadReport.content)
        print("Report downloaded:","report-"+key+"-"+value+".tar.gz\n")
    else:
        print("Failed to download file",downloadReport.status_code)

# downloadVerification = requests.get ('http://ec2-52-10-54-138.us-west-2.compute.amazonaws.com:18080/verifications/reports/ffaaf4a6-933c-4e56-8e8a-edd99a4006aa-1681789314949')
# print (downloadVerification.status_code)
# print (downloadVerification)

print (cBlue+'\n=====\n[EOF]\n=====\n'+cReset)
