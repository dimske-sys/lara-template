export COMPOSE_PROJECT_NAME=environment3
export WEB_PORT_HTTP=80
export WEB_PORT_SSL=443
export XDEBUG_CONFIG=main
export INNODB_USE_NATIVE_AIO=1

# Determine if .env file exist
ifneq ("$(wildcard .env)","")
	include .env
endif

ifndef INSIDE_DOCKER_CONTAINER
	INSIDE_DOCKER_CONTAINER = 0
endif

HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)
PHP_USER := -u www-data
PROJECT_NAME := -p ${COMPOSE_PROJECT_NAME}
INTERACTIVE := $(shell [ -t 0 ] && echo 1)
ERROR_ONLY_FOR_HOST = @printf "\033[33mThis command for host machine\033[39m\n"
.DEFAULT_GOAL := help
ifneq ($(INTERACTIVE), 1)
	OPTION_T := -T
endif
ifeq ($(GITLAB_CI), 1)
	# Determine additional params for phpunit in order to generate coverage badge on GitLabCI side
	PHPUNIT_OPTIONS := --coverage-text --colors=never
endif

help: ## Shows available commands with description
	@echo "\033[34mList of available commands:\033[39m"
	@grep -E '^[a-zA-Z-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "[32m%-27s[0m %s\n", $$1, $$2}'

build: ## Build dev environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose.yml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-test: ## Build test or continuous integration environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-test-ci.yml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-staging: ## Build staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-staging.yml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-prod: ## Build prod environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-prod.yml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

start: ## Start dev environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose.yml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-test: ## Start test or continuous integration environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-test-ci.yml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-staging: ## Start staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-staging.yml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-prod: ## Start prod environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-prod.yml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop: ## Stop dev environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose.yml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-test: ## Stop test or continuous integration environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-test-ci.yml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-staging: ## Stop staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-staging.yml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-prod: ## Stop prod environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose -f docker-compose-prod.yml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

restart: stop start ## Stop and start dev environment
restart-test: stop-test start-test ## Stop and start test or continuous integration environment
restart-staging: stop-staging start-staging ## Stop and start staging environment
restart-prod: stop-prod start-prod ## Stop and start prod environment

env-dev: ## Creates config for dev environment
	@make exec cmd="cp ./.env.dev ./.env"

env-test-ci: ## Creates config for test/ci environment
	@make exec cmd="cp ./.env.test-ci ./.env"

ssh: ## Get bash inside laravel docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-root: ## Get bash as root user inside laravel docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose $(PROJECT_NAME) exec $(OPTION_T) laravel bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-nginx: ## Get bash inside nginx docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose $(PROJECT_NAME) exec nginx /bin/sh
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-supervisord: ## Get bash inside supervisord docker container (cron jobs running there, etc...)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose $(PROJECT_NAME) exec supervisord bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-mysql: ## Get bash inside mysql docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose $(PROJECT_NAME) exec mysql bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

exec:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@$$cmd
else
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel $$cmd
endif

exec-bash:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@bash -c "$(cmd)"
else
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel bash -c "$(cmd)"
endif

exec-by-root:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) docker-compose $(PROJECT_NAME) exec $(OPTION_T) laravel $$cmd
else
	$(ERROR_ONLY_FOR_HOST)
endif

report-prepare:
	@make exec cmd="mkdir -p reports/coverage"

report-clean:
	@make exec-by-root cmd="rm -rf reports/*"

wait-for-db:
	@make exec cmd="php artisan db:wait"

composer-install-no-dev: ## Installs composer no-dev dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-dev"

composer-install: ## Installs composer dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader"

composer-update: ## Updates composer dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer update"

key-generate: ## Sets the application key
	@make exec cmd="php artisan key:generate"

info: ## Shows Php and Laravel version
	@make exec cmd="php artisan --version"
	@make exec cmd="php artisan env"
	@make exec cmd="php --version"

logs: ## Shows logs from the laravel container. Use ctrl+c in order to exit
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-laravel
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-nginx: ## Shows logs from the nginx container. Use ctrl+c in order to exit
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-nginx
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-supervisord: ## Shows logs from the supervisord container. Use ctrl+c in order to exit
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-supervisord
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-mysql: ## Shows logs from the mysql container. Use ctrl+c in order to exit
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-mysql
else
	$(ERROR_ONLY_FOR_HOST)
endif

drop-migrate: ## Drops databases and runs all migrations for the main/test databases
	@make exec cmd="php artisan migrate:fresh"
	@make exec cmd="php artisan migrate:fresh --env=test"

migrate-no-test: ## Runs all migrations for main database
	@make exec cmd="php artisan migrate --force"

migrate: ## Runs all migrations for main/test databases
	@make exec cmd="php artisan migrate --force"
	@make exec cmd="php artisan migrate --force --env=test"

seed: ## Runs all seeds for test database
	@make exec cmd="php artisan db:seed --force"

phpunit: ## Runs PhpUnit tests
	@make exec cmd="./vendor/bin/phpunit -c phpunit.xml --coverage-html reports/coverage $(PHPUNIT_OPTIONS) --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

report-code-coverage: ## Updates code coverage on coveralls.io. Note: COVERALLS_REPO_TOKEN should be set on CI side.
	@make exec-bash cmd="export COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN} && php ./vendor/bin/php-coveralls -v --coverage_clover reports/clover.xml --json_path reports/coverals.json"

phpcs: ## Runs PHP CodeSniffer
	@make exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR12 --colors -p src/App tests"

ecs: ## Runs Easy Coding Standard tool
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache check src/App tests"

ecs-fix: ## Runs Easy Coding Standard tool to fix issues
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache --fix check src/App tests"

phpmetrics: ## Generates phpmetrics static analysis report
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@mkdir -p reports/phpmetrics
	@if [ ! -f reports/junit.xml ] ; then \
		printf "\033[32;49mjunit.xml not found, running tests...\033[39m\n" ; \
		./vendor/bin/phpunit -c phpunit.xml --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml ; \
	fi;
	@echo "\033[32mRunning PhpMetrics\033[39m"
	@php ./vendor/bin/phpmetrics --version
	@php ./vendor/bin/phpmetrics --junit=reports/junit.xml --report-html=reports/phpmetrics .
else
	@make exec-by-root cmd="make phpmetrics"
endif

phpcpd: ## Runs php copy/paste detector
	@make exec cmd="php phpcpd.phar --fuzzy src/App tests"

phpmd: ## Runs php mess detector
	@make exec cmd="php ./vendor/bin/phpmd src/App text phpmd_ruleset.xml --suffixes php"

phpstan: ## Runs PhpStan static analysis tool
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHPStan - PHP Static Analysis Tool\033[39m"
	@php artisan cache:clear --env=test
	@./vendor/bin/phpstan --version
	@./vendor/bin/phpstan analyze src/App tests --xdebug
else
	@make exec cmd="make phpstan"
endif

composer-normalize: ## Normalizes composer.json file content
	@make exec cmd="composer normalize"

composer-validate: ## Validates composer.json file content
	@make exec cmd="composer validate --no-check-version"

composer-require-checker: ## Checks the defined dependencies against your code
	@make exec-bash cmd="XDEBUG_MODE=off php ./vendor/bin/composer-require-checker"

composer-unused: ## Shows unused packages by scanning and comparing package namespaces against your code
	@make exec-bash cmd="XDEBUG_MODE=off php ./vendor/bin/composer-unused"