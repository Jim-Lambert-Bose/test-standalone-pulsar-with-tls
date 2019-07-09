FROM apachepulsar/pulsar:2.3.1

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get update
RUN apt install -y less lsof libnss3-tools golang jq emacs-nox

# broker.conf and proxy.conf with TLS enabled
COPY *.conf /pulsar/conf/
COPY *.yml /pulsar/conf/

# mkcert manages the CA and all the cert/keys it creates
RUN go get -u github.com/FiloSottile/mkcert && $(go env GOPATH)/bin/mkcert
ENV GOROOT /usr/lib/go
ENV GOBIN /usr/bin/go
ENV PATH="/pulsar/bin:/root/go/bin/:${PATH}"
RUN mkdir /pulsar/secrets
WORKDIR /pulsar

# create a cert/key for pulsar
RUN mkcert --key-file key.pem --cert-file cert.pem standalone-pulsar.org "*.standalone-pulsar.org" standalone-pulsar.test localhost 127.0.0.1 ::1
# cp the CA cert to a known location
RUN cp /root/.local/share/mkcert/rootCA.pem /pulsar/rootCA.pem  
# make a cert/key for the pulsar proxy to connect to the brokers
RUN mkcert --cert-file proxy-cert.pem --key-file proxy-key.pem --client standalone-puslar-proxy
# make a superuser cert/key for the pulsar clients, when used within the container
RUN mkcert --cert-file client-cert.pem --key-file client-key.pem --client standalone-pulsar-admin


## tmp to use openssl certs for test
WORKDIR /pulsar
COPY gen-openssl*.sh /pulsar/
RUN ls -ltra
RUN touch /root/.rnd
RUN /bin/bash -c ./gen-openssl-ca.sh 
RUN ./gen-openssl-server-cert.sh

# generate an admin cert with a CN in the subject
#RUN ./gen-openssl-admin-cert-bad.sh  

# generate an admin cert with a SAN and no CN
RUN ./gen-openssl-admin-cert.sh


# COPY *.pem /pulsar/

ENV SERVICE_URL http://127.0.0.1:8080
EXPOSE 80

CMD ["supervisord", "-n"]
