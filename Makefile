COMPOSE_PATH := ./srcs/docker-compose.yml
ENV_PATH := ./srcs/.env

all: build up

build:
	if [ ! -d "/home/rmatsuba/data/mariadb" ]; then mkdir -p /home/rmatsuba/data/mariadb; fi
	if [ ! -d "/home/rmatsuba/data/wordpress" ]; then mkdir -p /home/rmatsuba/data/wordpress; fi
	# if [ ! -d "/Users/ryutaro320515/development/inception/data/mariadb" ]; then mkdir -p /Users/ryutaro320515/development/inception/data/mariadb; fi
	# if [ ! -d "/Users/ryutaro320515/development/inception/data/wordpress" ]; then mkdir -p /Users/ryutaro320515/development/inception/data/wordpress; fi
	docker compose -f $(COMPOSE_PATH) --env-file $(ENV_PATH) build

up:
	docker compose -f $(COMPOSE_PATH) --env-file $(ENV_PATH) up -d

down:
	docker compose -f $(COMPOSE_PATH) --env-file $(ENV_PATH) down

restart:
	$(MAKE) down
	$(MAKE) up

clean:
	docker compose -f $(COMPOSE_PATH) --env-file $(ENV_PATH) down --volumes --remove-orphans
	docker volume prune -f
	docker network prune -f
	docker image prune -f

rm:
	docker image rm nginx mariadb wordpress

log-nx:
	docker logs nginx

log-md:
	docker logs mariadb

log-wp:
	docker logs wordpress

ps:
	docker ps

nginx:
	docker exec -it nginx bash

mariadb:
	docker exec -it mariadb bash

wordpress:
	docker exec -it wordpress bash

.PHONY: all build up down restart clean
