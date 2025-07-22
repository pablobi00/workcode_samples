#!/bin/bash

DB_IP=$1
KEYSTORE=$2

# create keys
printf '\n==========  create keys ========================================================\n'

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ca-$DB_IP.key -out ca-$DB_IP.crt -subj "/C=US/ST=Washington/L=Kirkland/O=WANdisco01/OU=Sales/CN=ca-$DB_IP"

# Databricks
printf '\n===========  Server 01 =========================================================\n'

keytool -genkeypair -keyalg rsa -keystore $KEYSTORE -storepass changeit -alias DB_$DB_IP -keysize 2048 -dname "CN=$DB_IP,OU=Sale01,O=WANdisco01,L=Kirkland,S=Washington,C=US"
keytool -certreq -alias DB_$DB_IP -keystore "$KEYSTORE" -storepass changeit -file $DB_IP.csr
openssl x509 -req -in DB_$DB_IP.csr -CA ca-$DB_IP.crt -CAkey ca-$DB_IP.key -out DB_$DB_IP.crt -days 365 -CAcreateserial -CAserial DB_$DB_IP.seq


# Import key into ca keystore
printf '\n===========  Import keys ===================================================\n'

keytool -import -alias ca-$DB_IP -file ca-$DB_IP.crt -keystore $KEYSTORE -keypass changeit -storepass changeit

# Verify keys
printf '\n===========  Verify keys=========================================================\n'

printf '\n\n===  %s  ==============================\n' $DB_IP
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias DB_$DB_IP

# keytool -list -keystore /usr/lib/jvm/jre1.8.0_221/lib/security/cacerts -storepass changeit 

printf '\n=======\n[EOL]\n'