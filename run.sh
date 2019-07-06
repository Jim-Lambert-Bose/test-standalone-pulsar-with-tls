#!/bin/bash

export SECRETS_HOME=$PWD/secrets
export DATA_HOME=$PWD/pulsar-data
mkdir -p $DATA_HOME
mkdir -p $SECRETS_HOME
docker run \
    -it \
    -p 8443:8443 -p 6650:6650 -p 8081:8080 \
    -v $DATA_HOME:/pulsar/data \
    -v $SECRETS_HOME:/pulsar/secrets \
    go-pubsub/pulsar:2.3.1 bin/pulsar standalone
    
