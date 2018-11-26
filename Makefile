ROOT_DOCKER:=./docker
ROOT_API:=./api
ROOT_API_CONTAINER:=/var/www/api
COMPOSE_API_VERSION_MIN:=1.35
ENV=dev
ERR_MSG_INVALID_ENV="Error: Not a valid environment value."

# Check if the terminal is a Cygwin/Mintty
WINPTY_PREFIX:=winpty
ifneq ($(mintty --version 2>nul),"")
	TTY_PREFIX:=$(WINPTY_PREFIX)
endif

help:
	@echo "Options:"
	@echo " up                   - Create and start all containers for development. Codebase is shared."
	@echo " up ENV=prod          - Create and start all containers for production. Codebase is copied inside container."
	@echo " clear-cache          - Clear Symfony cache in development, shared local filesystem."
	@echo " clear-cache ENV=prod - Clear Symfony cache in production, inside container filesystem."
	@echo " clear-cache-legacy   - Clear Symfony cache in dev/prod inside container, require variable APP_ENV."
	@echo " unit-test            - Start Unit tests."
	@echo " integration-test     - Start Integration tests."
	@echo " functional-test      - Start Functional tests."
	@echo " test                 - Start all tests."
	@echo " log                  - Show logs."
	@echo " start                - Start all containers."
	@echo " stop                 - Stop all containers."
	@echo " down                 - Stop and remove containers, networks, images, and volumes."

docker-common:
	@export COMPOSE_API_VERSION=$(COMPOSE_API_VERSION_MIN)

up:
	@echo "Creating and starting containers..."
	@./docker/bin/rebuild_base_containers.sh
ifeq ($(ENV), dev)
	@echo "Enviroment: Development"
	cd $(ROOT_DOCKER) && \
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.dev.yml \
		up -d --build
	@echo "URL http://localhost"
else ifeq ($(ENV), prod)
	@echo "Enviroment: Production"
	cd $(ROOT_DOCKER) && \
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.prod.yml \
		up -d --build
else
	@echo $(ERR_MSG_INVALID_ENV)
	@exit 1
endif

clear-cache: docker-common
	@echo "Clearing symfony cache..."
ifeq ($(ENV), dev)
	@cd $(ROOT_API) && \
	php bin/console cache:clear --env=dev
else ifeq ($(ENV), prod)
	@cd $(ROOT_DOCKER) && \
	$(TTY_PREFIX) docker-compose exec -w $(ROOT_API_CONTAINER) php sudo -u www-data php bin/console cache:clear --no-warmup --no-debug --env=prod
else
	@echo $(ERR_MSG_INVALID_ENV)
	@exit 1
endif

clear-cache-legacy: docker-common
	@echo "Clearing symfony cache..."
	@cd $(ROOT_DOCKER) && \
	$(TTY_PREFIX) docker-compose exec -w $(ROOT_API_CONTAINER) php sudo -u www-data php bin/console cache:clear

unit-test:
	@./bin/unit-test.sh

integration-test:
	@./bin/integration-test.sh

functional-test:
	@./bin/functional-test.sh

test: unit-test integration-test functional-test

log:
	@echo "Logs:"
	@cd $(ROOT_DOCKER) && \
	docker-compose logs

start:
	@echo "Starting containers..."
	@cd $(ROOT_DOCKER) && \
	docker-compose start

stop:
	@echo "Stoping containers..."
	@cd $(ROOT_DOCKER) && \
	docker-compose stop

down:
	@echo "Stoping and removing containers, networks, images, and volumes..."
	@cd $(ROOT_DOCKER) && \
	docker-compose down

.PHONY: help up clear-cache unit-test integration-test functional-test test log start stop down
