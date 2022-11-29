# <p align="center">Security Tutorial (SSL/TLS)</p>

SSL is abbreviation of Secure Sockets Layer and TLS is abbreviation of Transport Layer Security. Also, SSL was
deprecated in 1999 but, it is still user to refer for related technologies.</b>
SSL and TLS are protocols to make secure (authenticated and encrypted) connection between network nodes. Current TLS
version is [1.3](https://www.rfc-editor.org/rfc/rfc8446) and standard port is 443.

## <p align="center">Table of Content</p>
- **[Prerequisite](#Prerequisite)**
- **[Concepts](concepts.md)**

## Prerequisite

* [OpenSSL](https://www.openssl.org/)
* [Docker](https://www.docker.com/)
* Podman
  * [Podman](https://podman.io/)
  * [Podman-compose](https://github.com/containers/podman-compose)
  * [Podman Desktop](https://podman-desktop.io/)


```shell
#!/bin/bash

openssl version
# step 1: ca
# generate private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout ca-key.pem -out ca-cert.pem -subj "/C=IR/ST=Tehran/L=Tehran/O=CA Home/OU=Developing/CN=*.ca.home/emailAddress=ca.home@gmail.com"
openssl x509 -in ca-cert.pem -noout -text

# step 2: server
# generate private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout server-key.pem -out server-req.pem -subj "/C=IR/ST=Tehran/L=Tehran/O=Server Home/OU=Developing/CN=*.server.home/emailAddress=server.home@gmail.com"

# step 3: sign
# sign server's CSR by CA's private key
echo subjectAltName=DNS:*.server.home.com,DNS:localhost,IP:0.0.0.0 > server-ext.cnf
openssl x509 -req -in server-req.pem -days 365 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile server-ext.cnf
openssl x509 -in server-cert.pem -noout -text

# verify the server certificate
openssl verify -CAfile ca-cert.pem server-cert.pem
```
