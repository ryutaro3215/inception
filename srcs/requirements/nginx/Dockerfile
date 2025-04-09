# setting docker image of nginx with openssl
# use ubuntu which is not the latest version as base image
# generating secret key and self-signed certification in ./tools/entorypoint.sh
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    nginx \
    openssl && \
    rm -rf /var/lib/apt/lists/*
# need not apt-get clean

ENV SSL_CERT_DIR=/etc/nginx/ssl \
    NGINX_CONF_PATH=/etc/nginx

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./conf/nginx.conf ${NGINX_CONF_PATH}/nginx.conf 
COPY ./conf/test.conf ${NGINX_CONF_PATH}/conf.d/test.conf

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/www/html && echo "Nginx with SSL" >> /var/www/html/index.html 

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

