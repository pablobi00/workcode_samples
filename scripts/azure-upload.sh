#!/bin/bash

for i in {1..5}
do 
  for j in {1..10}
  do
   az storage blob upload --account-name <storage_account> --auth-mode login --container gen2-west2-01 -f ./1gData.txt -n /folder-c/folder-c$i/1gdata00$j.txt
   printf 'Directory %s File %s uploaded \n' $i $j
  done
done  

printf '\n=======\n[EOL]\n'
