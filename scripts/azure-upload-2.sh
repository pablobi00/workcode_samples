#!/bin/bash

# Replace these values with your ADLS information
account_name="<storage acocunt>"
filesystem_name="pablob-live-source-a"
directory_name="more-data"
local_file_path="/Users/pablobarcenas/temporal/"
source_file_name="text10m.txt"
storage_account_key="<keys>"

# destination_file_name="text10m1.txt"

for i in {1..3}
do
    destination_file_name="text10m$i.txt"
    az storage blob upload --account-name $account_name --account-key $storage_account_key --container $filesystem_name -f $local_file_path$source_file_name -n /$directory_name/$destination_file_name

    printf 'File %s has been uploaded as %s\n' "$source_file_name" "$destination_file_name"
done

printf "\e[0;36m\n===== [EOF] =======\n\e[0m\n\n"
