#!/bin/bash

declare -A ARRAY=([pablobown0]=11.0.0.47 [pablobown1]=11.0.0.15 [pablobown2]=11.0.0.30 [pablobomn0]=11.0.0.25 [pabloboun0]=11.0.0.6) 
echo ${ARRAY[1]}
for i in '${!ARRAY[@]}'
do
echo $i
done