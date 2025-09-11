#! /bin/sh

if [ ! -f "./wp-config.php" ];
then
	>&2 echo Started Wordpress download
	wp core download --allow-root

	wp config create --allow-root \
				 --dbname=$DB_NAME \
				 --dbuser=$DB_USER \
				 --dbpass=$DB_USER_PASS \
				 --dbhost=mariadb:3306

	wp db create --allow-root

	wp core install --allow-root \
					--url="gd-harco.42.fr" \
					--title="Projet de merde" \
					--admin_user="$WP_ADMIN_USER" \
					--admin_password="$WP_ADMIN_PASS" \
					--admin_email="$WP_ADMIN_MAIL"

	wp user create "$WP_BASE_USER" "$WP_BASE_EMAIL" --allow-root \
													--user_pass="$WP_BASE_PASSWORD"


else
	>&2 echo Wordpress already installed
fi

# php-fpm start
mkdir -p /run/php/

php-fpm -F
