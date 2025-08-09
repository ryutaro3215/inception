# setting docker image of mariaDB
# use ubuntu which is not the latest version as base image
# making a new root user and wordpress user in init.sh
# configuration file is in ./conf/default.conf

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	mariadb-server \
	mariadb-client \
	vim \
	&& rm -rf /var/lib/apt/lists/* /var/lib/mysql/*

# COPY ./conf/default.conf /etc/mysql/conf.d/default.conf
COPY ./conf/default.conf /etc/mysql/my.cnf
COPY ./tools/entrypoint.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]
