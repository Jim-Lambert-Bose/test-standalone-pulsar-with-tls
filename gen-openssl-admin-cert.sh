#!/bin/bash


openssl req -new -newkey rsa:2048 -nodes \
        -keyout client-key.pem -days 365 -out client-cert.csr -config <(
cat <<-EOF

[ req ]
prompt = no
default_bits        = 2048
default_keyfile     = key.pem
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
CN=standalone-pulsar-admin

[ extensions ]
subjectKeyIdentifier        = hash
#authorityKeyIdentifier  = keyid,issuer

basicConstraints        = CA:FALSE
keyUsage            = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage    = clientAuth
nsComment           = "OpenSSL Generated Certificate"


EOF
)


openssl x509 -req -days 365 -out client-cert.pem -CA rootCA.pem -CAkey rootCA-key.pem  -CAcreateserial  -in client-cert.csr -extensions req -extfile <(
cat <<EOF
[ req ]
subjectKeyIdentifier        = hash
authorityKeyIdentifier  = keyid,issuer

basicConstraints        = CA:FALSE
keyUsage            = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage    = clientAuth
nsComment           = "OpenSSL Generated Certificate"

EOF
)
