#!/usr/bin/env bash

# seven g1  ###   s00188vmedap06001.pfx

# seven g2  ###   s00188vmedap06061.pfx

# Servers reset password  -----------------------------------------------------

printf '\n======= Step 1 - reset cert password \n'

# change password to changeit

keytool -keypasswd -keystore s00188vmedap06001.pfx -alias s00188vmedap06001
keytool -keypasswd -keystore s00188vmedap06061.pfx -alias s00188vmedap06061

printf '\n======= Step 2 - reset cert password (enter old password again) \n'

keytool -storepasswd -keystore s00188vmedap06001.pfx -alias s00188vmedap06001
keytool -storepasswd -keystore s00188vmedap06061.pfx -alias s00188vmedap06061

# import certificates

printf '\n======= Step 3 - import certificates in cacerts \n'

keytool -importkeystore -srckeystore s00188vmedap06001.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt
keytool -importkeystore -srckeystore s00188vmedap06061.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt

printf '\n====== Test import was succefull (use -v for verbose display) \n'

keytool -list -keystore cacerts -storepass changeit -alias s00188vmedap06001
keytool -list -keystore cacerts -storepass changeit -alias s00188vmedap06061

printf '\n=======\n[EOL]\n'
