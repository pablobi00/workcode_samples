#!/bin/bash

FUSION01=$1
FUSION02=$2
KEYSTORE=$3

printf  "\n---> Enter 3 parameters - Name of the 2 certificates and absolute path to keystore (castore)\n\n"
printf "SERVER01 =  %s\nSERVER02 = %s\nKEYSTORE = %s\n" $FUSION01 $FUSION02 $KEYSTORE
read -p "---> [press enter]"

# backup original castore (verify version)

cp $KEYSTORE $KEYSTORE.ori

# Servers -----------------------------------------------------

openssl pkcs12 -export -in $FUSION01.pem -name $FUSION01 -out $FUSION01.p12 -passin pass:wandisco@123 -passout pass:changeit
keytool -importkeystore -srckeystore $FUSION01.p12 -srcstoretype pkcs12 -destkeystore $KEYSTORE -trustcacerts -keypass changeit -srcstorepass changeit -deststorepass changeit -noprompt

openssl pkcs12 -export -in $FUSION02.pem -name $FUSION02 -out $FUSION02.p12 -passin pass:wandisco@123 -passout pass:changeit
keytool -importkeystore -srckeystore $FUSION02.p12 -srcstoretype pkcs12 -destkeystore $KEYSTORE -trustcacerts -keypass changeit -srcstorepass changeit -deststorepass changeit -noprompt

printf '\n=======\n[EOL]\n'