#!/bin/bash

FUSION01=s00187vmedapfusion07351
FUSION02=s00187vmedapfusion07451
KEYSTORE=/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts

printf  "\n---> Enter 3 parameters - FQDN for 2 Fusion servers and absolute path to keystore (castore)\n\n"
printf "SERVER01 =  %s\nSERVER02 = %s\nKEYSTORE = %s\n" $FUSION01 $FUSION02 $KEYSTORE
read -p "---> [press enter]"


# backup original castore (verify version)

cp $KEYSTORE $KEYSTORE.preoriGen1

# create keys
printf '\n==========  create keys ========================================================\n'

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ca-wandisco01g1.key -out ca-wandisco01g1.crt -subj "/C=US/ST=Washington/L=Kirkland/O=WANdisco01g1/OU=Sales/CN=WANdiscoCA01g1"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ca-wandisco02g1.key -out ca-wandisco02g1.crt -subj "/C=US/ST=Washington/L=Kirkland/O=WANdisco02g1/OU=Sales/CN=WANdiscoCA02g1"

# Server 01
printf '\n===========  Server 01 =========================================================\n'

keytool -genkeypair -keyalg rsa -keystore $KEYSTORE -storepass changeit -alias $FUSION01 -keysize 2048 -dname "CN=$FUSION01,OU=Sale01,O=WANdisco01,L=Kirkland,S=Washington,C=US"
keytool -certreq -alias $FUSION01 -keystore $KEYSTORE -storepass changeit -file $FUSION01.csr
openssl x509 -req -in $FUSION01.csr -CA ca-wandisco01g1.crt -CAkey ca-wandisco01g1.key -out $FUSION01.crt -days 365 -CAcreateserial -CAserial $FUSION01.seq

# Server 02
printf '\n===========  Server 02 =========================================================\n'

keytool -genkeypair -keyalg rsa -keystore $KEYSTORE -storepass changeit -alias $FUSION02 -keysize 2048 -dname "CN=$FUSION02,OU=Sale02,O=WANdisco02,L=Kirkland,S=Washington,C=US"
keytool -certreq -alias $FUSION02 -keystore $KEYSTORE  -storepass changeit -file $FUSION02.csr
openssl x509 -req -in $FUSION02.csr -CA ca-wandisco02g1.crt -CAkey ca-wandisco02g1.key -out $FUSION02.crt -days 365 -CAcreateserial -CAserial $FUSION02.seq

# Import key into ca keystore
printf '\n===========  Import keys ===================================================\n'

keytool -import -alias WANdiscoCA01g1 -file ca-wandisco01g1.crt -keystore $KEYSTORE -keypass changeit -storepass changeit
keytool -import -alias WANdiscoCA02g2 -file ca-wandisco02g1.crt -keystore $KEYSTORE -keypass changeit -storepass changeit

# Verify keys
printf '\n===========  Verify keys=========================================================\n'

printf '\n\n===  %s  ==============================\n' $FUSION01
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION01
printf '\n\n===  %s  ==============================\n' $FUSION02
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION02

# keytool -list -keystore /usr/lib/jvm/jre1.8.0_221/lib/security/cacerts -storepass changeit 

printf '\n=======\n[EOL]\n'