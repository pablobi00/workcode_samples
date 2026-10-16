#!/bin/bash

# Starbucks Gen1 - 2 servers - using IPs as FQDN - self-signed certificates and CA

# ------>>>>>> Change the blob to the correct one for the existing environment - upload .jar file in there

wget --quiet -O /databricks/jars/fusion-databricks-client.jar https://wdcentralus.blob.core.windows.net/databricks/fusion-databricks-client-azure.jar

# verify crt files are in FileStore and cacerts path

# import CA

keytool -import -alias WANdiscoCA01 -file /dbfs/FileStore/certs/ca-wandisco01.crt -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts  -keypass changeit -storepass changeit -noprompt
keytool -import -alias WANdiscoCA02 -file /dbfs/FileStore/certs/ca-wandisco02.crt -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts  -keypass changeit -storepass changeit -noprompt

# import certificate

keytool -import -alias 10.164.64.6 -file /dbfs/FileStore/certs/10.164.64.6.crt -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -keypass changeit -storepass changeit -noprompt
keytool -import -alias 10.164.64.7 -file /dbfs/FileStore/certs/10.164.64.7.crt -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -keypass changeit -storepass changeit -noprompt