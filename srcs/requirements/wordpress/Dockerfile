# setting docker image of wordpress with php-fpm
# use ubuntu which is not the latest version as base image
# there are 3 step
# 1. install php and php-fpm
# 2. install wordpress
# 3. exec entrypoint.sh

FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# --- install PHP 8.1 on Debian Bullseye ---
RUN apt-get update && apt-get install -y lsb-release apt-transport-https ca-certificates curl gnupg2 && \
    curl -sSL https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y \
        php8.1-fpm php8.1-mysql php8.1-curl php8.1-gd php8.1-mbstring \
        php8.1-xml php8.1-zip php8.1-bcmath mariadb-client \
        wget curl unzip less vim && \
    rm -rf /var/lib/apt/lists/*
# add listening 9000 tcp port
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.1/fpm/pool.d/www.conf

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
