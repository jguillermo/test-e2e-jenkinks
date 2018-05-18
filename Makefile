.DEFAULT_GOAL := help

## GENERAL ##
OWNER 			= aptitus
SERVICE_NAME 	= testrestfull

## RESULT_VARS ##
ENV 			?= lab
export TAG_DEPLOY = 1.8
PROJECT_NAME      = $(OWNER)-$(ENV)-$(SERVICE_NAME)
export REPOSITORY_TEST = $(PROJECT_NAME)-test
export REPOSITORY_SERVER = $(PROJECT_NAME)-server
export REPOSITORY_SERVER_FAKE = $(PROJECT_NAME)-server-fake

include deploy/cloudformation/Makefile

test: ## Test project : make test
	docker-compose -f docker-compose.test.yml run --rm test

test-restart: ## Test project
	docker-compose -f docker-compose.test.yml down
	make test

test-down: ## Test project
	docker-compose -f docker-compose.test.yml down

test-ps: ## Test project
	docker-compose -f docker-compose.test.yml ps

build-test: ## build image node
	docker build -t $(REPOSITORY_TEST):$(TAG_DEPLOY) ./docker/node

build-server: ## build image server
	docker build -t $(REPOSITORY_SERVER):$(TAG_DEPLOY) ./docker/server

build-server-fake: ## build image server fake
	docker build -t $(REPOSITORY_SERVER_FAKE):$(TAG_DEPLOY) ./docker/server-fake

build: ## build image to dev: make build
	make build-test build-server build-server-fake

## Target Help ##
help:
	@printf "\033[31m%-16s %-59s %s\033[0m\n" "Target" "Help" "Usage"; \
	printf "\033[31m%-16s %-59s %s\033[0m\n" "------" "----" "-----"; \
	grep -hE '^\S+:.*## .*$$' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' | sort | awk 'BEGIN {FS = ":"}; {printf "\033[32m%-16s\033[0m %-58s \033[34m%s\033[0m\n", $$1, $$2, $$3}'
