#!/bin/bash

FUSION01=$1
FUSION02=$2
FUSION03=$3
FUSION04=$4
KEYSTORE=$5

# example generatesssl-4server-v1 gusioneast01 fusioneast02 fusioncentral01 fusioncentral02 /usr/lib/jvm/security/cacerts

printf  "\n---> Enter 53 parameters - FQDN for 4 Fusion servers and absolute path to keystore (castore)\n\n"
printf "SERVER01 =  %s\nSERVER02 = %s\nSERVER03 =  %s\nSERVER04 =  %s\nKEYSTORE = %s\n" $FUSION01 $FUSION02 $FUSION02 $FUSION04 $KEYSTORE
read -p "---> press [enter] to continue or [Ctrl-C] to exit"


# backup original castore (verify version)

cp $KEYSTORE $KEYSTORE.ori

# create keys
printf '\n==========  create CA keys ========================================================\n'

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ca-wandisco01.key -out ca-wandisco01.crt -subj "/C=US/ST=Washington/L=Kirkland/O=WANdisco01/OU=Sales/CN=WANdiscoCA01"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ca-wandisco02.key -out ca-wandisco02.crt -subj "/C=US/ST=Washington/L=Kirkland/O=WANdisco02/OU=Sales/CN=WANdiscoCA02"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ca-wandisco03.key -out ca-wandisco03.crt -subj "/C=US/ST=Washington/L=Kirkland/O=WANdisco03/OU=Sales/CN=WANdiscoCA03"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ca-wandisco04.key -out ca-wandisco04.crt -subj "/C=US/ST=Washington/L=Kirkland/O=WANdisco04/OU=Sales/CN=WANdiscoCA04"

# Server 01
printf '\n===========  Server 01 =========================================================\n'

keytool -genkeypair -keyalg rsa -keystore $KEYSTORE -storepass changeit -alias $FUSION01 -keysize 2048 -dname "CN=$FUSION01,OU=Sale01,O=WANdisco01,L=Kirkland,S=Washington,C=US"
keytool -certreq -alias $FUSION01 -keystore $KEYSTORE -storepass changeit -file $FUSION01.csr
openssl x509 -req -in $FUSION01.csr -CA ca-wandisco01.crt -CAkey ca-wandisco01.key -out $FUSION01.crt -days 365 -CAcreateserial -CAserial $FUSION01.seq

# Server 02
printf '\n===========  Server 02 =========================================================\n'

keytool -genkeypair -keyalg rsa -keystore $KEYSTORE -storepass changeit -alias $FUSION02 -keysize 2048 -dname "CN=$FUSION02,OU=Sale02,O=WANdisco02,L=Kirkland,S=Washington,C=US"
keytool -certreq -alias $FUSION02 -keystore $KEYSTORE  -storepass changeit -file $FUSION02.csr
openssl x509 -req -in $FUSION02.csr -CA ca-wandisco02.crt -CAkey ca-wandisco02.key -out $FUSION02.crt -days 365 -CAcreateserial -CAserial $FUSION02.seq


# Server 03
printf '\n===========  Server 03 =========================================================\n'

keytool -genkeypair -keyalg rsa -keystore $KEYSTORE -storepass changeit -alias $FUSION03 -keysize 2048 -dname "CN=$FUSION03,OU=Sale03,O=WANdisco03,L=Kirkland,S=Washington,C=US"
keytool -certreq -alias $FUSION03 -keystore $KEYSTORE  -storepass changeit -file $FUSION03.csr
openssl x509 -req -in $FUSION03.csr -CA ca-wandisco03.crt -CAkey ca-wandisco03.key -out $FUSION03.crt -days 365 -CAcreateserial -CAserial $FUSION03.seq

# Server 04
printf '\n===========  Server 04 =========================================================\n'

keytool -genkeypair -keyalg rsa -keystore $KEYSTORE -storepass changeit -alias $FUSION04 -keysize 2048 -dname "CN=$FUSION04,OU=Sale04,O=WANdisco04,L=Kirkland,S=Washington,C=US"
keytool -certreq -alias $FUSION04 -keystore $KEYSTORE  -storepass changeit -file $FUSION04.csr
openssl x509 -req -in $FUSION04.csr -CA ca-wandisco04.crt -CAkey ca-wandisco04.key -out $FUSION04.crt -days 365 -CAcreateserial -CAserial $FUSION04.seq


# Import key into ca keystore
printf '\n===========  Import CA keys for trust chain ===================================================\n'

keytool -import -alias WANdiscoCA01 -file ca-wandisco01.crt -keystore $KEYSTORE -keypass changeit -storepass changeit
keytool -import -alias WANdiscoCA02 -file ca-wandisco02.crt -keystore $KEYSTORE -keypass changeit -storepass changeit
keytool -import -alias WANdiscoCA03 -file ca-wandisco03.crt -keystore $KEYSTORE -keypass changeit -storepass changeit
keytool -import -alias WANdiscoCA04 -file ca-wandisco04.crt -keystore $KEYSTORE -keypass changeit -storepass changeit


# Verify keys
printf '\n===========  Verify keys=========================================================\n'

printf '\n\n===  %s  ==============================\n' $FUSION01
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION01
printf '\n\n===  %s  ==============================\n' $FUSION02
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION02
printf '\n\n===  %s  ==============================\n' $FUSION03
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION03
printf '\n\n===  %s  ==============================\n' $FUSION04
keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION04

# List all certificates in store
# keytool -list -keystore /usr/lib/jvm/jre1.8.0_221/lib/security/cacerts -storepass changeit 

printf '\n=======\n[EOL]\n'