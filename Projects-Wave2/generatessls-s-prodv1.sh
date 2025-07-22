
# Servers -----------------------------------------------------

# change password to changeit

keytool -keypasswd -keystore s00188vmedap05501.pfx -alias s00188vmedap05501
keytool -keypasswd -keystore s00188vmedap06071.pfx -alias s00188vmedap06071
keytool -keypasswd -keystore s00188vmedap08181.pfx -alias s00188vmedap08181
keytool -keypasswd -keystore s00188vmedap08261.pfx -alias s00188vmedap08261
keytool -storepasswd -keystore s00188vmedap05501.pfx -alias s00188vmedap05501
keytool -storepasswd -keystore s00188vmedap06071.pfx -alias s00188vmedap06071
keytool -storepasswd -keystore s00188vmedap08181.pfx -alias s00188vmedap08181
keytool -storepasswd -keystore s00188vmedap08261.pfx -alias s00188vmedap08261

# import certificates

keytool -importkeystore -srckeystore s00188vmedap05501.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass changeit -srcstorepass changeit -deststorepass changeit -noprompt
keytool -importkeystore -srckeystore s00188vmedap06071.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt
keytool -importkeystore -srckeystore s00188vmedap08181.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt
keytool -importkeystore -srckeystore s00188vmedap08261.pfx -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass  changeit -srcstorepass  changeit -deststorepass changeit -noprompt

printf '\n=======\n[EOL]\n'

