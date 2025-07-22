#!/usr/bin/python
import json
import requests


OutputFile = open ('/Users/pablobarcenas/Library/CloudStorage/OneDrive-Personal/Education/OtherCode/Projects-Wave2/python/migrations.json')
# OutputFile = open ('/Users/pablobarcenas/Library/CloudStorage/OneDrive-Personal/Education/OtherCode/Projects-Wave2/python/migrations2.json')

# allData = json.load(OutputFile)
# print (json.dumps(allData,indent=4))

print ('Type allData:', type(allData))

# print(allData['exclusions'])

print ('----------------------------------------------------------------')


allData2 = requests.get('http://pablob-ubuntu18-001a.westus2.cloudapp.azure.com:18080/stats').json()
# print (json.dumps(allData2,indent=4))
print ('Type allData2:', type(allData2))

# print(allData2['exclusions'])

print ('------------------------------\n')

# Deserialization

allData3 = requests.get('http://pablob-ubuntu18-001a.westus2.cloudapp.azure.com:18080/migrations').json()
print("Type of deserialized data allData3: ", type(allData3))

for i in allData3:
    if isinstance(i, dict):
       for key, value in i.items():
                theKey = key
                if theKey=='migrationId' or theKey=='state':
                        print(key, value)
    
# OutputFile.close()