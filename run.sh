#!/bin/bash

## simple docker run script that defines volumes for:
# secrets: used to share client certs back out of the standalone container
# data: used to store pulsar data


export SECRETS_HOME=$PWD/secrets
export DATA_HOME=$PWD/pulsar-data
mkdir -p $DATA_HOME
mkdir -p $SECRETS_HOME
docker run \
    --name standalone-pulsar \
    -it \
    -p 8443:8443 -p 6651:6651 -p 6650:6650 -p 8080:8080 \
    -v $DATA_HOME:/pulsar/data \
    -v $SECRETS_HOME:/pulsar/secrets \
    go-pubsub/pulsar:2.3.1 bin/pulsar standalone
    

docker rm standalone-pulsar
