-include .env

help: ## Display available make commands
	@if command -v awk >/dev/null 2>&1; then \
		awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
			/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } \
			/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST); \
	else \
		echo ""; \
		echo "Usage:"; \
		echo "  make <target>"; \
		echo ""; \
		echo "Available targets:"; \
		findstr /R "^[a-zA-Z_-]*:.*##" $(MAKEFILE_LIST) | sed "s/:.*##/ - /"; \
	fi

.PHONY=install-symfony start stop cc php composer-install composer-update create-database migrations fixtures

##@ Setup

install-symfony: ## Install symfony
	@echo -n "Are you sure you want to (re)install Symfony (current Symfony project will be lost?) [y/N] " && read ans && [ $${ans:-N} = y ]
	@echo "Installing Symfony version \"${SYMFONY_VERSION}\"..."
	rm -rf apps/back && mkdir apps/back
	docker compose run --rm --no-deps composer-install composer create-project symfony/skeleton:${SYMFONY_VERSION} back
	docker compose stop
	make start

install-symfony-webapp: ## Install Symfony (full webapp)
	@echo -n "Are you sure you want to (re)install Symfony (current Symfony project will be lost)? [y/N] " && read ans && [ $${ans:-N} = y ]
	@echo "Installing Symfony WebApp version \"${SYMFONY_VERSION}\"..."
	rm -rf apps/back && mkdir apps/back
	docker compose run --rm --no-deps composer-install composer create-project symfony/skeleton:${SYMFONY_VERSION} back
	docker compose run --rm --no-deps composer-install sh -c "cd back && composer require webapp --no-interaction"
	docker compose stop
	make start

##@ General

start: ## Start project
	docker compose up -d 

stop: ## Stop project
	docker compose stop

cc:  ## Clear cache
	docker compose run --rm --no-deps php php bin/console cache:clear

php: ## Run bash console in php container
	docker compose run --rm php bash

##@ Composer
composer-install: ## Install composer dependencies
	docker compose run --rm --no-deps php composer install

composer-update: ## Update composer dependencies
	docker compose run --rm --no-deps php composer update

##@ Symfony
create-database: ## Create database
	docker compose run --rm --no-deps php php bin/console doctrine:database:create

migrations: ## Execute migrations
	docker compose run --rm --no-deps php php bin/console doctrine:migrations:migrate

fixtures: ## Load fixtures
	docker compose run --rm --no-deps php php bin/console doctrine:fixtures:load