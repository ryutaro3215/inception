#!/bin/sh

set -eux

#make /etc/nginx/ssl directory
mkdir -p ${SSL_CERT_DIR}

CRT=$SSL_CERT_DIR/nginx.crt
CSR=$SSL_CERT_DIR/nginx.csr
KEY=$SSL_CERT_DIR/nginx.key

if [ ! -f "$CRT" ] || [ ! -f "$KEY" ]; then
	echo "Generating secret key"
	openssl genrsa -out $KEY 2048
	echo "Generating CSR"
	openssl req -new -key $KEY -out $CSR -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/OU=42Tokyo/CN=rmatsuba.42.jp"
	echo "Generating CRT" 
	openssl x509 -days 398 -req -signkey $KEY -in $CSR -out $CRT
	echo "removing CSR"
	rm -f $CSR
else
	echo "CRT and KEY already exist, skipping generation"
fi

echo "Starting nginx"

nginx -g 'daemon off;'
