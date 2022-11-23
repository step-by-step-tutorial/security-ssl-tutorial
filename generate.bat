echo off

del *.pem

openssl version

openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout ca-key.pem -out ca-cert.pem -subj "/C=IR/ST=Tehran/L=Tehran/O=CA Home/OU=Developing/CN=*.ca.home/emailAddress=ca.home@gmail.com"
openssl x509 -in ca-cert.pem -noout -text

openssl req -newkey rsa:4096 -nodes -keyout server-key.pem -out server-req.pem -subj "/C=IR/ST=Tehran/L=Tehran/O=Server Home/OU=Developing/CN=*.server.home/emailAddress=server.home@gmail.com"

echo subjectAltName=DNS:*.server.home.com,DNS:localhost,IP:0.0.0.0 > server-ext.cnf
openssl x509 -req -in server-req.pem -days 365 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile server-ext.cnf
openssl x509 -in server-cert.pem -noout -text

openssl verify -CAfile ca-cert.pem server-cert.pem