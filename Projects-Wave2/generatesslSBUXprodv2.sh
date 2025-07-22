# Add Gen2-central certificates only
### s00188vmedap11461.pfx
### s00188vmedap11462.pfx

# Gen1-central
### s00188vmedap08181.pfx
### s00188vmedap08261.pfx

# Gen2-east2
### s00188vmedap05501.pfx
### s00188vmedap06071.pfx


# Servers reset password  -----------------------------------------------------

printf '\n======= Step 1 - reset cert password \n'


# change password to changeit

# keytool -keypasswd -keystore s00188vmedap05501.pfx -alias s00188vmedap05501
# keytool -keypasswd -keystore s00188vmedap06071.pfx -alias s00188vmedap06071
# keytool -keypasswd -keystore s00188vmedap08181.pfx -alias s00188vmedap08181
# keytool -keypasswd -keystore s00188vmedap08261.pfx -alias s00188vmedap08261

keytool -keypasswd -keystore s00188vmedap11461.pfx -alias s00188vmedap11461
keytool -keypasswd -keystore s00188vmedap11462.pfx -alias s00188vmedap11462

printf '\n======= Step 2 - reset cert password (enter old password again) \n'


# keytool -storepasswd -keystore s00188vmedap05501.pfx -alias s00188vmedap05501
# keytool -storepasswd -keystore s00188vmedap06071.pfx -alias s00188vmedap06071
# keytool -storepasswd -keystore s00188vmedap08181.pfx -alias s00188vmedap08181
# keytool -storepasswd -keystore s00188vmedap08261.pfx -alias s00188vmedap08261

keytool -storepasswd -keystore s00188vmedap11461.pfx -alias s00188vmedap11461
keytool -storepasswd -keystore s00188vmedap11462.pfx -alias s00188vmedap11462

# import certificates

printf '\n======= Step 2 - import certificates in cacerts \n'


# keytool -importkeystore -srckeystore s00188vmedap05501.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass changeit -srcstorepass changeit -deststorepass changeit -noprompt
# keytool -importkeystore -srckeystore s00188vmedap06071.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt
# keytool -importkeystore -srckeystore s00188vmedap08181.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt
# keytool -importkeystore -srckeystore s00188vmedap08261.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt

keytool -importkeystore -srckeystore s00188vmedap11461.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt
keytool -importkeystore -srckeystore s00188vmedap11462.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt

printf '\n=======\n[EOL]\n'