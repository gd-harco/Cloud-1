# ********* VAR ******** #
NAME			=	inception

COMPOSE_PATH	=	srcs/docker-compose.yml

COMP_CMD		=	docker compose

MKDIR			=	mkdir -p

VOLUMES_PATH	=	/home/$(USER)/data
# ********* RULES ******** #

all:	up

nginx :
	docker build srcs/requirements/nginx -t nginx

wp :
	docker build srcs/requirements/wordpress -t wordpress

maria:
	docker build srcs/requirements/mariadb -t mariadb
up:
	make volumes
	${COMP_CMD} -f ${COMPOSE_PATH} up --build -d

bg_up:
	make volumes
	${COMP_CMD} -f ${COMPOSE_PATH} up --build -d

volumes:
	${MKDIR} ${VOLUMES_PATH}/wordpress
	${MKDIR} ${VOLUMES_PATH}/mariadb

re:
	make down
	make up
down:
	${COMP_CMD} -f ${COMPOSE_PATH} down --rmi all -v --remove-orphans

.phony: nginx wp maria up bg_up volumes re
