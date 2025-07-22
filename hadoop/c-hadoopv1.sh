#!/bin/bash

# Add files in Hadoop via loops v.1 2020.11.18

for i in {15..20}
do
   # echo /bi_reports/fact_customer_type/partition_as_of_date=19$i
   hadoop fs -mkdir /bi_reports/fact_customer_type/partition_as_of_date=19$i
   hadoop fs -mkdir /bi_reports/fact_customer_type/partition_as_of_date=20$i
   if [[ $i -eq 20 ]]
   then
      echo Done ---> 19$i 20$i
   fi
   for j in {1..10}
   do
     # echo "/bi_reports/fact_customer_type/partition_as_of_date=19$i/file0$j"
      hadoop fs -put /etc/hosts/  /bi_reports/fact_customer_type/partition_as_of_date=19$i/file0$j
      hadoop fs -put /etc/hosts/  /bi_reports/fact_customer_type/partition_as_of_date=20$i/file0$j
   done
done

printf '\n======[EOL]\n\n'