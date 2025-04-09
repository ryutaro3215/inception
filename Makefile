COMPOSE_PATH := ./srcs/docker-compose.yml
ENV_PATH := ./srcs/.env

all: build up

build:
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

.PHONY: all build up down restart clean
