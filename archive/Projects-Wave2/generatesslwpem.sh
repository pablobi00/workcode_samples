
keytool -import -alias s00187vmedapfusion07351 -file ./s00187vmedapfusion07351.pem -keystore ./cacerts -keypass wandisco@123 -storepass changeit -noprompt
keytool -import -alias s00187vmedapfusion07451 -file ./s00187vmedapfusion07451.pem -keystore ./cacerts -keypass wandisco@123 -storepass changeit -noprompt
keytool -import -alias s00187vmedapfusion08021 -file ./s00187vmedapfusion08021.pem -keystore ./cacerts -keypass wandisco@123 -storepass changeit -noprompt
keytool -import -alias s00187vmedapfusion08211 -file ./s00187vmedapfusion08211.pem -keystore ./cacerts -keypass wandisco@123 -storepass changeit -noprompt

keytool -list -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -storepass changeit | grep s00187vmedapfusion
keytool -list -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -storepass changeit | grep 10.1

keytool -list -keystore ./cacerts -storepass changeit | grep s00187vmedapfusion
keytool -list -keystore ./cacerts -storepass changeit | grep 10.1

keytool -v  -list -keystore $KEYSTORE -storepass changeit -alias $FUSION01

keytool -v  -list -keystore ./cacerts -storepass changeit -alias $FUSION01