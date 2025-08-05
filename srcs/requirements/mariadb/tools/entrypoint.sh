#!/bin/bash
set -eux

check_run_mysqld() {
	echo "[check] checking /run/mysqld..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld

	# Remove stale socket file if exists
	if [ -S /run/mysqld/mysqld.sock ]; then
		echo "[cleanup] removing stale mysqld.sock"
		rm -f /run/mysqld/mysqld.sock
	fi
}

init_mariadb() {
	echo "[init] initializing mariadb..."
	chown -R mysql:mysql /var/lib/mysql
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db

	echo "[init] creating user and database..."
	/usr/sbin/mariadbd --user=mysql --bootstrap <<< "
	FLUSH PRIVILEGES;
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
	FLUSH PRIVILEGES;
	"
	touch /var/lib/mysql/.initialized
}

start_mariadb() {
	echo "[Start] Starting MariaDB..."
	exec /usr/sbin/mariadbd --user=mysql
}

main() {
	check_run_mysqld
	init_mariadb
	start_mariadb
}

main "$@"
