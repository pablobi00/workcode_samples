#!/usr/bin/env bash

cp ./count_new.xml ./count_old.xml
curl --insecure https://localhost:8084/plugins/migrator/getAll | xmllint -format - > ./count_new.xml

if [ -z $1 ]
then
  printf '\nNo dated output file provided ==== \n'
else
  cp count_new.xml $1
fi

printf '\n ===== Previous =====\n'
printf 'SCHEDULED = ' ; grep SCHEDULED ./count_old.xml | wc -l
printf 'WARMING UP = ' ; grep  WARMING ./count_old.xml | wc -l
printf 'RUNNING = ' ; grep  RUNNING ./count_old.xml | wc -l
printf 'FINISHING = ' ; grep FINISHING ./count_old.xml | wc -l
printf 'FINISHED = ' ; grep FINISHED ./count_old.xml | wc -l
printf 'ABORTED = ' ; grep ABORTED count_old.xml |  wc -l
printf 'PAUSED = ' ; grep PAUSED ./count_old.xml | wc -l

printf '\n ===== Current =====\n'
printf 'SCHEDULED = ' ; grep SCHEDULED ./count_new.xml | wc -l
printf 'WARMING UP = ' ; grep  WARMING ./count_new.xml | wc -l
printf 'RUNNING = ' ; grep  RUNNING ./count_new.xml | wc -l
printf 'FINISHING = ' ; grep FINISHING ./count_new.xml | wc -l
printf 'FINISHED = ' ; grep FINISHED ./count_new.xml | wc -l
printf 'ABORTED = ' ; grep ABORTED count_new.xml |  wc -l
printf 'PAUSED = ' ; grep PAUSED ./count_new.xml | wc -l

printf '\n====\n[EOF]\n'