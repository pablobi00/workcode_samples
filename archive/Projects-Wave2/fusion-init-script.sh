#!/bin/bash

echo "---------------------- WANdisco FUSION INIT SCRIPT ---------------------"

# import certificates

keytool -importkeystore -srckeystore /dbfs/FileStore/certs/s00188vmedap08181.pfx -srcstoretype pkcs12 -destkeystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt

keytool -importkeystore -srckeystore /dbfs/FileStore/certs/s00188vmedap08261.pfx -srcstoretype pkcs12 -destkeystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt

# Obtain the Fusion client library
cp -u /dbfs/FileStore/wandisco/fusion-databricks-client.jar /databricks/jars/fusion-databricks-client.jar

echo "------------------ DONE ------------------"