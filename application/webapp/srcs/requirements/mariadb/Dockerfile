############ MARIADB DOCKERFILE ############

FROM debian:oldstable

LABEL createdBy="gd-harco" mail="gd-harco@student.42lyon.fr"

# Import environment variables
ARG DB_ROOT_PASS
ARG DB_NAME
ARG DB_USER
ARG DB_USER_PASS

# Install MariaDB
RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y mariadb-server && \
	apt-get clean && \
	rm -fr /var/lib/apt/lists/*

# Create a database
RUN service mariadb start && mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};" \
					&& mariadb -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';" \
					&& mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';" \
					&& mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';" \
					&& mariadb -e "FLUSH PRIVILEGES;"

# expose MariaDB port
EXPOSE 3306

# Start MariaDB
CMD [ "mariadbd", "--user=root", "--bind-address=0.0.0.0" ]
