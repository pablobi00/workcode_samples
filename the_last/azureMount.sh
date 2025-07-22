#!/bin/bash

# azureMount.sh - version 1.0 2020.12.09

# Mount a ADLSgen2 FS as SMB 
# Temporary mount ---> for permanent see ----> https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux

printf '\n===== [ Step 0  - az login ] =======\n'

az login

printf '\n===== [ Step 1 - Ensure port 445 is open - connection to Gen2 ] =======\n'

resourceGroupName="SALES-pablo.barcenas1"
storageAccountName="<storage_account>"

# This command assumes you have logged in with az login
httpEndpoint=$(az storage account show \
	            --resource-group $resourceGroupName \
		        --name $storageAccountName \
		            --query "primaryEndpoints.file" | tr -d '"')
smbPath=$(echo $httpEndpoint | cut -c7-$(expr length $httpEndpoint))
fileHost=$(echo $smbPath | tr -d "/")

nc -zvw3 $fileHost 445

printf '\n==== [ Step 2 - Use the mount command to create mount point ] ========\n'

resourceGroupName="SALES-pablo.barcenas1"
storageAccountName="<storage_account>"
fileShareName="pablob-fs-001"

mntPath="/mnt/$storageAccountName/$fileShareName"

sudo mkdir -p $mntPath

printf '\n==== [ Step 3 - Mount the share ] ========\n'

httpEndpoint=$(az storage account show \
	    --resource-group $resourceGroupName \
	        --name $storageAccountName \
		    --query "primaryEndpoints.file" | tr -d '"')
smbPath=$(echo $httpEndpoint | cut -c7-$(expr length $httpEndpoint))$fileShareName

storageAccountKey=$(az storage account keys list \
	    --resource-group $resourceGroupName \
	        --account-name $storageAccountName \
		    --query "[0].value" | tr -d '"')

sudo mount -t cifs $smbPath $mntPath -o vers=3.0,username=$storageAccountName,password=$storageAccountKey,serverino

printf '\n====\n[ Verification]\n'

ll $mntPath

printf '\n====\n[EOL]\n'