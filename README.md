# standalone-pulsar-with-tls
Just an extention to the apachepulsar/pulsar:2.3.1 container that enables TLS and client authentication + authorization.

**Currently, authentication and authorization are not working.**

See also, the standalone-pulsar repo: https://github.com/apache/pulsar/tree/master/docker

## Usage
```bash
# build the container
./build.sh
```
```bash
# run the container
./run
```
```bash
# get the standalone container's rootCA.pem in ./secrets/ volume
./standalone-get-ca-cert
```
```bash
# create a client mTLS key and cert in the ./secrets/ volume
./standalone-mk-client-cert
```

```bash
# create a super user client mTLS key and cert in the ./secrets/ volume
./standalone-mk-superuser-client-cert
```

