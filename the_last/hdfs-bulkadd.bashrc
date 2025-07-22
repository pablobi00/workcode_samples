#!/bin/bash

dd if=/dev/urandom of=newfile.txt bs=10MB count=1
printf '\n'
for i in {1..3}
do
  for j in {1..10}
  do
        hadoop fs -put newfile.txt /ldm00$i/repl0$i/file0$j
        printf '\nfile /ldm00%s/repl0%s/file0%s\n' $i $i $j
  done
done
printf '\n======\n[EOL]\n'