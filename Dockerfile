# Use .dockerignore to skip crap
# docker build -t nginx-cac .
# docker run -p 60080:80 -p 60443:443 -t nginx-cac
# Connect browser to docker-machine IP https://192.168.99.100:60443/

FROM ubuntu:14.04
MAINTAINER Chris Shenton <chris@v-studios.com>

EXPOSE 80 443

RUN apt-get install -y openssl nginx wget

# FAIL: required passwd; generate manually then copy into place
#RUN openssl genrsa -des3 -out server.key.org 1024
#RUN openssl rsa -in server.key.org -out server.key
#RUN openssl req -new -key server.key -out server.csr
#RUN openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
COPY etc/nginx/ssl /etc/nginx/ssl

#RUN mkdir /etc/nginx/ssl
RUN chmod 700 /etc/nginx/ssl
RUN chmod 600 /etc/nginx/ssl/*
WORKDIR /etc/nginx/ssl


# DOD Root CA Certs, convert to PEM for nginx

RUN wget http://dodpki.c3pki.chamb.disa.mil/rel3_dodroot_2048.p7b
Run wget http://dodpki.c3pki.chamb.disa.mil/dodeca.p7b
RUN wget http://dodpki.c3pki.chamb.disa.mil/dodeca2.p7b

RUN openssl pkcs7 -inform DER -outform PEM -in rel3_dodroot_2048.p7b -out rel3_dodroot_2048.pem -print_certs
RUN openssl pkcs7 -inform DER -outform PEM -in dodeca.p7b -out dodeca.pem -print_certs
RUN openssl pkcs7 -inform DER -outform PEM -in dodeca2.p7b -out dodeca2.pem -print_certs

RUN cat rel3_dodroot_2048.pem dodeca.pem dodeca2.pem > dod-root-certs.pem

RUN cp rel3_dodroot_2048.pem /etc/ssl/certs
RUN cp dodeca.pem /etc/ssl/certs
RUN cp dodeca2.pem /etc/ssl/certs
RUN cp dod-root-certs.pem /etc/ssl/certs

# Nginx config

COPY etc/nginx/conf.d/cac.conf /etc/nginx/conf.d/
RUN service nginx restart

# How do I pause it and let us try to connect?
# Or run nginx in foreground
CMD /usr/sbin/nginx -g "daemon off;"
