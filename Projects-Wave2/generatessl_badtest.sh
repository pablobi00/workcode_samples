#!/bin/bash

FUSION01=$1
FUSION02=$2
KEYSTORE=$3

printf  "\n---> Enter 3 parameters - FQDN for 2 Fusion servers and absolute path to keystore (castore)\n\n"
read -p "---> Values: $FUSION01, $FUSION02 and $KEYSTORE [press enter]"

# backup original castore (verify version)

cp $KEYSTORE $KEYSTORE.ori

# create keys
printf '\n==========  create keys ========================================================\n'

openssl genrsa -des3 -out wandisco_fusion01.key 2048
openssl genrsa -des3 -out wandisco_fusion02.key 2048

# Server 01
printf '\n===========  Server 01 =========================================================\n'

openssl req -new -key  wandisco_fusion01.key -out $FUSION01.csr
openssl x509 -req -days 365 -in $FUSION01.csr -signkey wandisco_fusion01.key -out $FUSION01.crt
# openssl req -text -noout -verify -in $FUSION01.csr
# openssl x509 -text -noout -in $FUSION01.crt
keytool -import -alias $FUSION01 -file $FUSION01.crt -keystore $KEYSTORE -keypass changeit -storepass changeit

# Server 02
printf '\n===========  Server 02 =========================================================\n'

openssl req -new -key  wandisco_fusion02.key -out $FUSION01.csr
openssl x509 -req -days 365 -in $FUSION02.csr -signkey  wandisco_fusion02.key -out $FUSION02.crt
# openssl req -text -noout -verify -in $FUSION02.csr
# openssl x509 -text -noout -in $FUSION02.crt
keytool -import -alias $FUSION02 -file $FUSION02.crt -keystore $KEYSTORE -keypass changeit -storepass changeit


# Verify keys
printf '\n===========  Verify keys=========================================================\n'

printf '\n\n===  $FUSION01  ==============================\n'
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION01

printf '\n\n===  $FUSION02  ==============================\n'
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION02

printf '\n=======\n[EOL]\n'