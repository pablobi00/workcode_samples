
# Import   ca  -----> one or more files as in ca-<servername> 

# NOT REQUIRED --->  keytool -import -keystore cacerts -trustcacerts -alias ca-starbucks -file CA-starbucks.pem  -trustcacerts

# Servers -----------------------------------------------------

openssl pkcs12 -export -in s00187vmedapfusion07351.pem -name s00187vmedapfusion07351 -out s00187vmedapfusion07351.p12 -passin pass:wandisco@123 -passout pass:changeit
keytool -importkeystore -srckeystore s00187vmedapfusion07351.p12 -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass changeit -srcstorepass changeit -deststorepass changeit -noprompt

openssl pkcs12 -export -in s00187vmedapfusion07451.pem -name s00187vmedapfusion07451 -out s00187vmedapfusion07451.p12 -passin pass:wandisco@123 -passout pass:changeit
keytool -importkeystore -srckeystore s00187vmedapfusion07451.p12 -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass changeit -srcstorepass changeit -deststorepass changeit -noprompt

openssl pkcs12 -export -in s00187vmedapfusion08021.pem -name s00187vmedapfusion08021 -out s00187vmedapfusion08021.p12 -passin pass:wandisco@123 -passout pass:changeit
keytool -importkeystore -srckeystore s00187vmedapfusion08021.p12 -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass changeit -srcstorepass changeit -deststorepass changeit -noprompt

openssl pkcs12 -export -in s00187vmedapfusion08211.pem -name s00187vmedapfusion08211 -out s00187vmedapfusion08211.p12 -passin pass:wandisco@123 -passout pass:changeit
keytool -importkeystore -srckeystore s00187vmedapfusion08211.p12 -srcstoretype pkcs12 -destkeystore cacerts -trustcacerts -keypass changeit -srcstorepass changeit -deststorepass changeit -noprompt

printf '\n=======\n[EOL]\n'