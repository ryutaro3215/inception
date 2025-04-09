#!/bin/bash
set -eux

check_run_mysqld() {
	echo "[Check] Checking /run/mysqld..."
	if [ ! -d /run/mysqld ]; then
		mkdir -p /run/mysqld
		chown -R mysql:mysql /run/mysqld
	fi
}

init_mariadb() {
	if [ ! -f /var/lib/mysql/.initialized ]; then
		echo "[Init] Initializing MariaDB..."
		chown -R mysql:mysql /var/lib/mysql
		mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db

		echo "[Init] Creating user and database..."
		/usr/sbin/mariadbd --user=mysql --bootstrap <<-EOSQL
			FLUSH PRIVILEGES;
			ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
			CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
			CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
			GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
			FLUSH PRIVILEGES;
EOSQL

		touch /var/lib/mysql/.initialized
	fi
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
