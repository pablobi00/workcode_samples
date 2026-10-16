#!/bin/bash

fallocate -l 100M testfile.txt && \
hadoop fs -mkdir /datafiles && \
hadoop fs -put testfile.txt /datafiles/testfile1.txt && \
rm -f testfile.txt && \
for ((i=2;i<=5;i++)); do \
hadoop fs -cp /datafiles/testfile1.txt /datafiles/testfile$i.txt \
&& echo "Test file $i done"; done && \
echo "Adding temp files" && \
hadoop fs -cp /datafiles/testfile1.txt /datafiles/temporaryfile && \
hadoop fs -cp /datafiles/testfile1.txt /datafiles/fileistemporary && \
echo "Directory: " && \
hadoop fs -ls /datafiles

#!/bin/bash


 head -c 10485760  /dev/zero > testfile.txt

fallocate -l 100M testfile.txt && \
hadoop fs -put testfile.txt /demo/temporary.txt && \
hadoop fs -put testfile.txt /demo/temporary.txt && \
rm -f testfile.txt && \
printf  "\n====================\n[Demo directory content]\n" && \
hadoop fs -ls /demo/1GB


# current 

hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar teragen 10000000 /demo && \
head -c 10485760  /dev/zero > testfile.txt && \
hadoop fs -put testfile.txt /demo/temporary.txt && \
hadoop fs -put testfile.txt /demo/temp001.txt && \
for i in {1..3}; do hadoop fs -put testfile.txt /demo/customer$i; done
rm -f testfile.txt && \
printf  "\n====================\n[Demo directory content]\n" && \
hadoop fs -ls /demo


#!/bin/bash

dd if=/dev/urandom of=newfile.txt bs=10MB count=1
printf '\n'

for i in {1..3}
do
  for j in {1..10}
  do
        hadoop fs -put newfile.txt /demo/customer$i.csv
  done
done
printf '\n======\n[EOL]\n'



#!/bin/bash

for i in {1..3}
do
     printf '\n %s\n' $i
done
printf '\n======\n[EOL]\n'