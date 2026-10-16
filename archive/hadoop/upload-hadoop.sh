#!/bin/bash

SIZE=$1
TIMES=$2
WHERE=$3
printf "First parameter is file size, size format examples 1M, 5M or 1G\n"
printf "Second is number of files to copy\n"
printf "Third is the name of the folder where it will be replicated (based on Fusion's replication rule\n\n"
 
read -p "Create $TIMES testfiles of $SIZE and copy to $WHERE [press enter or Ctrl-C to exit]"
 
printf "\n======================\nCurrent $WHERE content:\n"
 
hadoop fs -ls -h /$WHERE/
 
for ((i=1;i<=TIMES;i++))
do
  fallocate -l "$SIZE" testfile$i.txt
done
 
hadoop fs -copyFromLocal testfile* /$WHERE/
rm testfile*.txt 
printf "\n======================\nNew $WHERE content:\n"
hadoop fs -ls -h /$WHERE/

printf "\n=====\n[EOL]\n"
