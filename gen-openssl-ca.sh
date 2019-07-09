###### PICK ONE OF THE TWO FOLLOWING ######


openssl genrsa -aes256 -passout pass:xxxx -out ca.pass.key 4096
openssl rsa -passin pass:xxxx -in ca.pass.key -out rootCA-key.pem
rm ca.pass.key

# whichever you picked, you should now have a `ca.key` file.

# now generate the CA root cert
# when prompted, use whatever you'd like, but i'd recommend some human-readable Organization
# and Common Name.
openssl req -new -x509 -days 3650 -key rootCA-key.pem -out rootCA.pem -config <(
cat <<-EOF

[ req ]
prompt = no
default_bits        = 2048
default_keyfile     = rootCA-key.pem
distinguished_name  = subject
req_extensions      = extensions
x509_extensions     = extensions
string_mask         = utf8only

[ subject ]
C=US
ST=MA
L=Framingham
O=openssl development certificate
OU=jimlambrt@Jims-MacBook-Pro-4.local
CN=openssl jimlambrt@Jims-MacBook-Pro-4.local  


[ extensions ]
subjectKeyIdentifier        = hash
authorityKeyIdentifier  = keyid,issuer

basicConstraints        = CA:TRUE
keyUsage                = critical, cRLSign, digitalSignature, keyCertSign
nsComment           = "OpenSSL Generated Certificate"

EOF
)
