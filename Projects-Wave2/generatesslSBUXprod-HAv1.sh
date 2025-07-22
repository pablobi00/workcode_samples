#!/usr/bin/env bash
# Gen1-zoneB
###  s00188vmedap12471.pfx

# Gen2-zoneB
### s00188vmedap12401.pfx

# Servers reset password  -----------------------------------------------------

printf '\n======= Step 1 - reset cert password \n'

# change password to changeit

keytool -keypasswd -keystore s00188vmedap12471.pfx -alias s00188vmedap12471
keytool -keypasswd -keystore s00188vmedap12401.pfx -alias s00188vmedap12401

printf '\n======= Step 2 - reset cert password (enter old password again) \n'

keytool -storepasswd -keystore s00188vmedap12471.pfx -alias s00188vmedap12471
keytool -storepasswd -keystore s00188vmedap12401.pfx -alias s00188vmedap12401

# import certificates

printf '\n======= Step 3 - import certificates in cacerts \n'

keytool -importkeystore -srckeystore s00188vmedap12471.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt
keytool -importkeystore -srckeystore s00188vmedap12401.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt

printf '\n=======\n[EOL]\n'