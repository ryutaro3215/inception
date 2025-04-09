#!/bin/bash

set -eux

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 2
done

echo "MariaDB is up and running!"

if [ ! -f /var/www/html/wp-config.php ]; then 
	echo "Creating wp-config.php..."
	wp config create \
		--dbname=${DB_NAME} \
		--dbuser=${DB_USER} \
		--dbpass=${DB_PASSWORD} \
		--dbhost=${DB_HOST} \
		--allow-root \
		--force \
		--path=/var/www/html
fi

echo "Installing WordPress..."
wp core install \
	--url=${URL} \
	--title=${TITLE} \
	--admin_user=${ADMIN_USER} \
	--admin_password=${ADMIN_PASSWORD} \
	--admin_email=${ADMIN_EMAIL} \
	--skip-email --allow-root --path=/var/www/html

echo "Creating additional user..."
if ! wp user get ${USER} --allow-root --path=/var/www/html > /dev/null 2>&1; then
    echo "Creating additional user..."
    wp user create \
        ${USER} \
        ${USER_EMAIL} \
        --role=author \
        --user_pass=${USER_PASSWORD} \
        --allow-root --path=/var/www/html
else
    echo "User ${USER} already exists. Skipping creation."
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/wp-content

echo "WordPress installation completed successfully!"
echo "Starting PHP-FPM..."

# Start PHP-FPM in the foreground
php-fpm8.1 -F
