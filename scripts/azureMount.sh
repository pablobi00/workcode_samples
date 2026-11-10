#!/bin/bash

# azureMount.sh - version 1.1 2026.11.10

# Mount an Azure Files share over SMB (Linux).
# Temporary mount ---> for permanent see ----> https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux

set -euo pipefail

resourceGroupName="SALES-pablo.barcenas1"
storageAccountName="<storage_account>"
fileShareName="pablob-fs-001"

mntPath="/mnt/$storageAccountName/$fileShareName"
credDir="/etc/smbcredentials"
credFile="$credDir/$storageAccountName.cred"

printf '\n===== [ Step 0 - az login ] =======\n'

az account show >/dev/null 2>&1 || az login

printf '\n===== [ Step 1 - Ensure port 445 is open to Azure Files ] =======\n'

httpEndpoint=$(az storage account show \
    --resource-group "$resourceGroupName" \
    --name "$storageAccountName" \
    --query "primaryEndpoints.file" \
    --output tsv)
smbBase="${httpEndpoint#https:}"           # //account.file.core.windows.net/
fileHost=$(echo "$smbBase" | tr -d "/")    # account.file.core.windows.net
smbPath="$smbBase$fileShareName"

nc -zvw3 "$fileHost" 445 || { echo "Port 445 to $fileHost is blocked - aborting."; exit 1; }

printf '\n==== [ Step 2 - Create mount point ] ========\n'

sudo mkdir -p "$mntPath"

printf '\n==== [ Step 3 - Write credentials file ] ========\n'

storageAccountKey=$(az storage account keys list \
    --resource-group "$resourceGroupName" \
    --account-name "$storageAccountName" \
    --query "[0].value" \
    --output tsv)

sudo mkdir -p "$credDir"
printf 'username=%s\npassword=%s\n' "$storageAccountName" "$storageAccountKey" \
    | sudo tee "$credFile" >/dev/null
sudo chmod 600 "$credFile"
unset storageAccountKey

printf '\n==== [ Step 4 - Mount the share ] ========\n'

sudo mount -t cifs "$smbPath" "$mntPath" \
    -o "vers=3.0,credentials=$credFile,uid=$(id -u),gid=$(id -g),dir_mode=0755,file_mode=0644,serverino"

printf '\n====\n[ Verification ]\n'

ls -l "$mntPath"

printf '\n====\n[EOL]\n'
