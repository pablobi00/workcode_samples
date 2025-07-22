#!/bin/bash

# Use  ./newmigration.sh e1fa5712-5409-11ea-885d-000d3aa50bab

curl -v --insecure -X PUT "https://localhost:8084/plugins/migrator/migrate?path=/WD-VIRTUAL-$1&donor=zone-central&beneficiary=zoneG2-central&startPath=&fsType=ADL&overwritePolicy=CLOBBER&iterationLimit=10000&pollTimer=1&dateAfterWhichToMigrate=0"

