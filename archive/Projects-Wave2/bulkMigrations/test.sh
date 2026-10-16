#!/usr/bin/env bash




curl -v\
     --header "Accept: application/json, text/plain, */*" \
     --header "Content-Type: application/json;charset=UTF-8" \
     --header "Cookie: JSESSIONID=1fmp0hiskmi90wl4oluuwop7a" \
     --header "authn-token: f297a226-208c-4099-9b3c-67baea400165" \
     --data "{"replicatedFolder":{"zones":[{"local":false,"id":"zoneG2-central","name":"zoneG2-central"},{"local":true,"id":"zone-central","name":"zone-central"}],"priorityZone":"zone-central","pathMap":{"zoneG2-central":"/data/published/Customer/Customer360/Customer360BehaviorRestricted/ver=01/","zone-central":"/data/published/Customer/Customer360/Customer360BehaviorRestricted/ver=01/"},"name":"W3c - /data/published/Customer/Customer360/Customer360BehaviorRestricted/ver=01/","excluded":["/**/.Trash/**","/**/.hive-staging**","/**/.snapshot/","/**/.snapshot","/**/.Trash"],"scheduleChecks":false}}" \
     --insecure https://localhost:8443/api/replicatedFolders
