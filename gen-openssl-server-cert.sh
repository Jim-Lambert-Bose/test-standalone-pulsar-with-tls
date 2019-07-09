#!/bin/bash


openssl req -new -newkey rsa:2048 -nodes \
        -keyout key.pem -days 365 -out cert.csr -config <(
cat <<-EOF
[ req ]
prompt = no
default_bits        = 2048
default_keyfile     = server-key.pem
distinguished_name  = subject
req_extensions      = extensions
x509_extensions     = extensions
string_mask         = utf8only

[ subject ]
C=US
ST=MA
L=Framingham
O=mkcert development certificate
OU=bose
CN=standalone-pulsar.org

[ extensions ]
subjectKeyIdentifier        = hash
#authorityKeyIdentifier  = keyid,issuer

basicConstraints        = CA:FALSE
keyUsage            = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage    = serverAuth
subjectAltName          = @alternate_names
nsComment           = "OpenSSL Generated Certificate"


[ alternate_names ]
DNS.1 = *.standalone-pulsar.org
DNS.2 = standalone-pulsar.test
DNS.3 = localhost
DNS.4 = 127.0.0.1
DNS.5 = ::1
EOF
)

openssl x509 -req -days 365 -out cert.pem -CA rootCA.pem -CAkey rootCA-key.pem  -CAcreateserial  -in cert.csr -extensions req -extfile <(
cat <<EOF
[ req ]
subjectKeyIdentifier        = hash
authorityKeyIdentifier  = keyid,issuer

basicConstraints        = CA:FALSE
keyUsage            = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage    = serverAuth
subjectAltName          = @alternate_names
nsComment           = "OpenSSL Generated Certificate"


[ alternate_names ]
DNS.1 = *.standalone-pulsar.org
DNS.2 = standalone-pulsar.test
DNS.3 = localhost
DNS.4 = 127.0.0.1
DNS.5 = ::1
EOF
)
