#!/bin/sh

# use /createrule.sh "W2 final - delta_log" /data/raw/Marketing/LoyaltyProgram/SRProgramEventsRestricted/ver=02/_delta_log/ zone-central zoneG2-central
# Insert cookie from Login

curl -v \
 --header "Accept: application/json, text/plain, */*" \
 --header "Content-Type: application/json;charset=UTF-8" \
 --data '{"username":"admin","password":"Kundera001"}' \
 --insecure \
 https://localhost:8443/api/authenticate/login
root@s00188vmedap08181:/home/wandiscoadmin/wandisco/scripts# cat createrule.sh
#!/bin/sh
if [ "$#" -eq 0 ]; then
  echo "Usage: <rulename> <path> <srczone> <targetzone>"
  exit 1
fi
RULENAME=$1
RULEPATH=$2
SRCZONE=$3
TGTZONE=$4
echo "Creating rule called: $RULENAME"
curl -v \
 --header "Accept: application/json, text/plain, */*" \
 --header "Content-Type: application/json;charset=UTF-8" \
 --header "Cookie: JSESSIONID=dm9h237kosgyt8nrinsnpiuu" \
 --header "authn-token: ad0b20d5-2ea6-455c-927d-cff185b103be" \
 --data "{\"replicatedFolder\":{\"zones\":[{\"local\":false,\"id\":\"$TGTZONE\",\"name\":\"$TGTZONE\"},{\"local\":true,\"id\":\"$SRCZONE\",\"name\":\"$SRCZONE\"}],\"priorityZone\":\"$SRCZONE\",\"pathMap\":{\"$TGTZONE\":\"$RULEPATH\",\"$SRCZONE\":\"$RULEPATH\"},\"name\":\"$RULENAME\",\"excluded\":[\"/**/.Trash/**\",\"/**/.hive-staging**\",\"/**/.snapshot/\",\"/**/.snapshot\",\"/**/.Trash\"],\"scheduleChecks\":false}}" \
 --insecure \
 https://localhost:8443/api/replicatedFolders

