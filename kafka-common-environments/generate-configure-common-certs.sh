#!/bin/bash

set -e

mkdir -p kafka-certs
cd kafka-certs
rm -rf *

# === CA ===
openssl req -new -x509 -keyout ca.key -out ca.crt -days 5475 -subj "/CN=localhost" -nodes

# === Server Cert ===
/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home/bin/keytool -genkey -alias kafka-server -keyalg RSA -keystore kafka.server.keystore.jks -storepass password -keypass password -dname "CN=localhost" -validity 5475
/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home/bin/keytool -certreq -alias kafka-server -keystore kafka.server.keystore.jks -file kafka-server.csr -storepass password
openssl x509 -req -CA ca.crt -CAkey ca.key -in kafka-server.csr -out kafka-server-signed.crt -days 5475 -CAcreateserial
/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home/bin/keytool -import -alias CARoot -keystore kafka.server.keystore.jks -file ca.crt -storepass password -noprompt
/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home/bin/keytool -import -alias kafka-server -keystore kafka.server.keystore.jks -file kafka-server-signed.crt -storepass password -noprompt
# === Truststore ===
/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home/bin/keytool -import -alias CARoot -keystore kafka.server.truststore.jks -file ca.crt -storepass password -noprompt
# === Credential files for Kafka config ===
echo password > keystore_certs
echo password > key_certs
echo password > truststore_certs
echo "✅ Certificates and keystores generated in kafka-certs/"
echo "You can now use these credentials in your Kafka configuration."
cp ../client.properties .
# === Python Client PEM Files ===
#openssl genrsa -out client.key 2048
#openssl req -new -key client.key -out client.csr -subj "/CN=localhost"
#openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key \
#  -CAcreateserial -out client.pem -days 3650

#cp ca.crt ca.pem  # Rename CA to expected name

#echo "✅ PEM files for Python created:"
#echo "- ca.pem"
#echo "- client.pem"
#echo "- client.key"