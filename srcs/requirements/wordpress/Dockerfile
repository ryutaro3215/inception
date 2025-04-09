# setting docker image of wordpress with php-fpm
# use ubuntu which is not the latest version as base image
# there are 3 step
# 1. install php and php-fpm
# 2. install wordpress
# 3. exec entrypoint.sh

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	php-fpm php-mysql php-curl php-gd php-mbstring \
	php-xml php-zip php-bcmath mariadb-client \
	wget curl unzip less vim \
	&& rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
RUN sed -i 's/listen = \/run\/php\/php8.1-fpm.sock/listen = 9000/g' /etc/php/8.1/fpm/pool.d/www.conf \
	&& sed -i 's/;listen.allowed_clients/listen.allowed_clients/g' /etc/php/8.1/fpm/pool.d/www.conf \
	&& sed -i 's/;clear_env/clear_env/g' /etc/php/8.1/fpm/pool.d/www.conf \
	&& sed -i 's/;pm.max_children/pm.max_children/g' /etc/php/8.1/fpm/pool.d/www.conf \
	&& sed -i 's/;pm.start_servers/pm.start_servers/g' /etc/php/8.1/fpm/pool.d/www.conf \
	&& sed -i 's/;pm.min_spare_servers/pm.min_spare_servers/g' /etc/php/8.1/fpm/pool.d/www.conf \
	&& sed -i 's/;pm.max_spare_servers/pm.max_spare_servers/g' /etc/php/8.1/fpm/pool.d/www.conf

ENV WORDPRESS_DIR=/var/www/html
WORKDIR ${WORDPRESS_DIR}

RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xzf latest.tar.gz --strip-components=1 && \
	rm -rf latest.tar.gz && \
	chown -R www-data:www-data ${WORDPRESS_DIR} && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
