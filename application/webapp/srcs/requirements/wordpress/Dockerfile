############ WP DOCKERFILE ############

FROM debian:oldstable

LABEL createdBy="gd-harco" mail="gd-harco@student.42lyon.fr"

#mettre a jour apt
#installation curl (pour recuperer wp-cli, php et ses dependances)
RUN	apt-get update \
	&& apt-get upgrade \
	&& apt-get install curl \
    	ca-certificates \
    	php-fpm \
    	php-mysql \
    	--no-install-recommends -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#si commande config create faile, ne pas renommer wp-cli.phar
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY script/wpconfig.sh ./wpconfig.sh

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf


#aucune action basique, juste une norme
EXPOSE 9000

CMD ["/bin/sh", "/var/www/html/wpconfig.sh"]
