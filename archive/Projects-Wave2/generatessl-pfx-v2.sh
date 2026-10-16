#!/usr/bin/env bash

for i in name1 name2

do
# Servers reset password  -----------------------------------------------------
    printf '\e[31m\n===== CERT: %s \e[0m\n' $i
# change password to changeit

    printf '\n======= Step 1 - reset cert password \n'
    keytool -keypasswd -keystore $i.pfx -alias $i

    printf '\n======= Step 2 - reset cert password (enter old password first - then changeit) \n'
    keytool -storepasswd -keystore $i.pfx -alias $i

# import certificates

    printf '\n======= Step 3 - import certificates in cacerts \n'
    keytool -importkeystore -srckeystore $i.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt

    printf '\n====== Test import was succefull (use -v for verbose display) \n'
    keytool -list -keystore cacerts -storepass changeit -alias $i

done

printf '\n=======\n[EOL]\n'
