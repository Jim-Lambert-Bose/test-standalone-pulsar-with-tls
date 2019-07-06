FROM apachepulsar/pulsar:2.3.1

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get update
RUN apt install -y less lsof libnss3-tools golang

COPY *.conf /pulsar/conf/


RUN go get -u github.com/FiloSottile/mkcert && $(go env GOPATH)/bin/mkcert
ENV GOROOT /usr/lib/go
ENV GOBIN /usr/bin/go
ENV PATH="/root/go/bin/:${PATH}"
RUN mkdir /pulsar/secrets
WORKDIR /pulsar
RUN mkcert --key-file key.pem --cert-file cert.pem standalone-pulsar.org "*.standalone-pulsar.org" standalone-pulsar.test localhost 127.0.0.1 ::1 
RUN cp /root/.local/share/mkcert/rootCA.pem /pulsar/rootCA.pem  

ENV SERVICE_URL http://127.0.0.1:8080
EXPOSE 80

CMD ["supervisord", "-n"]
